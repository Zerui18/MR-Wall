//
//  WallpaperManager.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public class WallpaperManager {
    
    // MARK: Private Properties
    private let persistenceManager: PersistenceManager
    private let urlSession = URLSession(configuration: .default)
    private let signedApiRequest: URLRequest = {
        let apiURL = URL(string: "https://api.mangarockhd.com/parse/functions/getWallpaperList")!
        var request = URLRequest(url: apiURL)
        request.allHTTPHeaderFields = [
            "x-parse-session-token": "r:92d628ea0b234a1557d0fa39555d4c8f",
            "x-parse-application-id": "DOTecsAUU0hHsVe50hQqCltNmpzx5hbwJB60FfyM",
            "x-parse-client-key": "lpY0gkLg4LOtrTAtNT1L1vwC1llTWkr0F8wusC5i"
        ]
        request.httpMethod = "POST"
        return request
    }()
    
    private struct Constants {
        fileprivate static let binaryBegin = "crop.json".data(using: .utf8)!
        fileprivate static let binaryEnd = "]PK".data(using: .utf8)!
        fileprivate static let maxRetryCount = 20
    }
    
    // MARK: Public Properties
    public var allWallpapers: [Wallpaper] {
        return persistenceManager.wallpapers
    }
    public var markedWallappers: [Wallpaper]
    
    // MARK: Public Init
    public init() {
        persistenceManager = PersistenceManager(model: "DataStore")
        markedWallappers = persistenceManager.wallpapers.filter {$0.marked}
    }
    
    // MARK: Private Methods
    private func parseWallpapersJson(data: Data)-> Bool {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any],
            let items = json["result", "items"] as? [[String: Any]] else {
            return false
        }
        for item in items {
            let name = item["name"] as! String
            let fileURL = item["fileUrl"] as! String
            self.persistenceManager.save(wallpaper: (name, fileURL))
        }
        return true
    }
    
    private func parseMWAJson(data: Data)-> (Double, Double){
        var article = data[data.range(of: Constants.binaryBegin)!.upperBound...]
        article = article[...article.range(of: Constants.binaryEnd)!.lowerBound]
        let json = try! JSONSerialization.jsonObject(with: article, options: []) as! [[String: Any]]
        let item = json.last!
        return ((item["imageWidth"] as! NSNumber).doubleValue, (item["imageHeight"] as! NSNumber).doubleValue)
    }
    
    private func loadSize(for wallpaper: Wallpaper, onComplete handler: @escaping (Bool)-> Void) {
        let metaURL = URL(string: wallpaper.fileURL!.replacingOccurrences(of: " ", with: "%20"))!
        
        urlSession.dataTask(with: metaURL) { (data, _, _) in
            guard let data = data else {
                handler(false)
                return
            }
            
            let size = self.parseMWAJson(data: data)
            wallpaper.width = size.0
            wallpaper.height = size.1
            handler(true)
        }.resume()
    }
    
    // MARK: Public Methods
    
    /**
     Refresh the local cache (both disk & mem) of Wallpaper's. Both 'new' and non-'new' wallpapers are retrieved.
     */
    public func refreshWallpapers(onComplete handler: @escaping (Bool)-> Void) {
        var returnCnt = 0
        var success = true
        for val in ["true", "false"] {
            var requestCopy = signedApiRequest
            requestCopy.httpBody = "{\"isNew\":\(val)}".data(using: .utf8)!
            urlSession.dataTask(with: requestCopy) { (data, response, error) in
                
                // pray for short circuit exec here
                if error != nil || !self.parseWallpapersJson(data: data!) {
                    success = false
                }
                
                returnCnt += 1
                if returnCnt == 2 {
                    handler(success)
                }
            }.resume()
        }
    }
    
    /**
     Wraps the entire process of fetching image's max size (if necessary) and recursively retrying to fetch the largest possible image, starting from the max-size retrieved. During the retries, the wallpaper object's size property is updated to the new values. Callback on background thread when completes.
     - parameters:
        - wallpaper: the Wallpaper object
        - handler: handler to be called on error or success
     */
    public func loadFullImage(for wallpaper: Wallpaper, onComplete handler: @escaping (UIImage?)-> Void) {
        
        // recursively retry (up to 10 times) fetching the largest valid image
        func fetchImage(retryCount: Int = 0) {
            guard retryCount < Constants.maxRetryCount else {
                handler(nil)
                return
            }
            urlSession.dataTask(with: wallpaper.imageURLFull) { (data, _, _) in
                
                // do not retry if failure is due to connectivity
                guard let data = data else {
                    handler(nil)
                    return
                }
                
                // data is valid image, callback
                if let image = UIImage(data: data) {
                    handler(image)
                }
                // data is invalid, retry with smaller size
                else {
                    wallpaper.width *= 0.9
                    wallpaper.height *= 0.9
                    fetchImage(retryCount: retryCount + 1)
                }
            }.resume()
        }
        
        if wallpaper.width != 0 {
            fetchImage()
        }
        else {
            loadSize(for: wallpaper) { (success) in
                if success {
                    fetchImage()
                }
                else {
                    handler(nil)
                }
            }
        }
    }
    
    /**
     Set the marked property of the Wallpaper to the given value, updates markedWallpapers accordingly.
     - returns: the index of the Wallpaper in markedWallpapers
     */
    public func setMarked(_ marked: Bool, of wallpaper: Wallpaper)-> Int{
        wallpaper.marked = marked
        
        let index: Int
        if marked {
            index = markedWallappers.insertSorted(wallpaper)
        }
        else {
            index = markedWallappers.index(of: wallpaper)!
            markedWallappers.remove(at: index)
        }
        
        return index
    }
    
}
