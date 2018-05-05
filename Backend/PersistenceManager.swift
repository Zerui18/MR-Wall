//
//  PersistenceManager.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import CoreData

class PersistenceManager {
    
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
        
        wallpapers = try! container.viewContext.fetch(Wallpaper.fetchRequest())
    }
    
    // MARK: Private Methods
    private func hasSaved(wallpaper: String)-> Bool {
        return wallpapers.contains(where: {
            $0.fileURL == wallpaper
        })
    }
    
    // MARK: Internal Methods
    func save(wallpaper: (String, String))-> Wallpaper? {
        if !hasSaved(wallpaper: wallpaper.1) {
            let obj = Wallpaper(context: container.viewContext)
            obj.fileURL = wallpaper.1
            return obj
        }
        return nil
    }
    
//    func save(wallpapers: [(String, String)]) {
//        for wallpaper in wallpapers {
//            save(wallpapers: <#T##[(String, String)]#>)
//        }
//    }

    func saveContext() throws {
        try container.viewContext.save()
    }
    
}
