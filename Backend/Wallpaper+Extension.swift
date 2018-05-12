//
//  Wallpaper+Extension.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

fileprivate var key1 = true

extension Wallpaper {
    
    public var imageURLThumb: URL {
        get {
            if let url = objc_getAssociatedObject(self, &key1) as? URL {
                return url
            }
            else {
                let url = getImageURL()
                objc_setAssociatedObject(self, &key1, url, .OBJC_ASSOCIATION_COPY)
                return url
            }
        }
    }
    
    public var imageURLFull: URL {
        return getImageURL(fullsize: true)
    }
    
    @inline(__always)
    private func getImageURL(fullsize: Bool = false)-> URL {
        let path = fileURL!.replacingOccurrences(of: "http:/", with: "").replacingOccurrences(of: ".mwa", with: "")
        if fullsize {
            return URL(string: "http://imangazo.mrcdn.info\(path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)/phone_\(Int(width))_\(Int(height))_fitInside.jpg")!
        }
        return URL(string: "http://imangazo.mrcdn.info\(path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)/list_\(800)_\(800)_fit.jpg")!
    }
    
}

extension Wallpaper: Comparable {
    public static func < (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.order < rhs.order
    }
}
