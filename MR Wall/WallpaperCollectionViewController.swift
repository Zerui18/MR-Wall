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
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let dim = (UIScreen.main.bounds.width-12) / 2
        layout.itemSize = CGSize(width: dim, height: dim)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        self.init(collectionViewLayout: layout)
    }
    
    // MARK: Private Properties
    private var isRefreshing = false {
        didSet {
            collectionView!.isUserInteractionEnabled = !isRefreshing
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = .white
        
        collectionView!.refreshControl = UIRefreshControl()
        collectionView!.register(WallpaperCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView!.refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
        title = "\(manager.allWallpapers.count) Wallpapers"
        return manager.allWallpapers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WallpaperCell
        cell.wallpaper = manager.allWallpapers[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = manager.allWallpapers[indexPath.item]
        navigationController!.pushViewController(WallpaperDetailViewController(wallpaper: wallpaper), animated: true)
    }

}

