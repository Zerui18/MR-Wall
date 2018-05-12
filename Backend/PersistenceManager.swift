//
//  PersistenceManager.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import CoreData

public class PersistenceManager {
    
    // MARK: Private Properties
    private let container: NSPersistentContainer
    
    // MARK: Internal Properties
    var wallpapers: [Wallpaper]
    
    // MARK: Internal Init
    init(model: String) {
        container = NSPersistentContainer(name: model)
        
        let g = DispatchGroup()
        g.enter()
        container.loadPersistentStores { (_, error) in
            if error != nil {
                fatalError(error!.localizedDescription)
            }
            g.leave()
        }
        g.wait()
        
        let request: NSFetchRequest<Wallpaper> = Wallpaper.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Wallpaper.order, ascending: true)]
        wallpapers = try! container.viewContext.fetch(request)
        NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: .main) { _ in
            try! self.saveContext()
        }
    }
    
    // MARK: Private Methods
    private func hasSaved(wallpaper: String)-> Bool {
        return wallpapers.contains(where: {
            $0.fileURL == wallpaper
        })
    }
    
    // MARK: Internal Methods
    func save(wallpaper: (String, String)) {
        if !hasSaved(wallpaper: wallpaper.1) {
            let obj = Wallpaper(context: container.viewContext)
            obj.fileURL = wallpaper.1
            obj.order = Int64(wallpapers.count)
            wallpapers.append(obj)
        }
    }

    // MARK: Public Methods
    func saveContext() throws {
        try container.viewContext.save()
    }
    
}
