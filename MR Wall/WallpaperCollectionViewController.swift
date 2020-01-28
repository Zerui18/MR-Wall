//
//  CollectionViewController.swift
//  MR Wall
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import Backend

let manager = WallpaperManager()

class WallpaperCollectionViewController: UICollectionViewController {
    
    // MARK: Init
    init(sourceRef: KeyPath<WallpaperManager, [Wallpaper]>) {
        self.sourceRef = sourceRef
        
        // calculate cell size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let dim = (UIScreen.main.bounds.width-12) / 2
        layout.itemSize = CGSize(width: dim, height: dim)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        super.init(collectionViewLayout: layout)
        
        // setup UI
        collectionView!.backgroundColor = .white
        collectionView!.register(WallpaperCell.self, forCellWithReuseIdentifier: "cell")
        
        if sourceRef == \WallpaperManager.allWallpapers {
            collectionView!.refreshControl = UIRefreshControl()
            collectionView!.refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        }
        
        NotificationCenter.default.addObserver(forName: .markStateChanged, object: nil, queue: .main) { (notification) in
            // decode params
            let obj = notification.object as! Wallpaper
            let index = notification.userInfo!["index"] as! Int
            let source = notification.userInfo!["source"] as! UICollectionView
            
            let target = [IndexPath(item: index, section: 0)]
            
            if source === self.collectionView! {
                if self.sourceRef == \WallpaperManager.markedWallappers {
                    if obj.marked {
                        self.collectionView!.insertItems(at: target)
                    }
                    else {
                        self.collectionView!.deleteItems(at: target)
                    }
                }
                return
            }
            
            // if update from 'marked' page, reload instead of insert & delete
            if self.sourceRef == \WallpaperManager.allWallpapers {
                self.collectionView!.reloadItems(at: target)
                return
            }
            else {
                if obj.marked {
                    self.collectionView!.insertItems(at: target)
                }
                else {
                    self.collectionView!.deleteItems(at: target)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Properties
    private let sourceRef: KeyPath<WallpaperManager, [Wallpaper]>
    private var isRefreshing = false {
        didSet {
            collectionView!.isUserInteractionEnabled = !isRefreshing
        }
    }
    
    // MARK: Private Methods
    @objc private func refresh(_ sender: UIRefreshControl) {
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        
        manager.refreshWallpapers { (success) in
            DispatchQueue.main.async {
                sender.endRefreshing()
                self.collectionView!.reloadData()
                self.isRefreshing = false
                if !success {
                    self.alert(title: "Error", message: "Failed to get new wallpapers, please ensure you have stable internet connection.")
                }
            }
        }
    }
    
    // MARK: CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = manager[keyPath: sourceRef].count
        title = "\(count) Wallpapers"
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WallpaperCell
        cell.wallpaper = manager[keyPath: sourceRef][indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = manager[keyPath: sourceRef][indexPath.item]
        navigationController!.pushViewController(WallpaperDetailViewController.create(wallpaper: wallpaper), animated: true)
    }

}

