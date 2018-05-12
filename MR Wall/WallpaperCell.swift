//
//  WallpaperCell.swift
//  MR Wall
//
//  Created by Chen Zerui on 6/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Backend
import UIKit
import Nuke

class WallpaperCell: UICollectionViewCell {
    
    // MARK: Private Properties
    private let imageView = UIImageView(frame: .zero)
    private let toggleButton = UIButton(type: .custom)
    
    var wallpaper: Wallpaper! {
        didSet {
            Nuke.loadImage(with: wallpaper.imageURLThumb, options: ImageLoadingOptions(transition: .fadeIn(duration: 1/3)), into: imageView)
            toggleButton.setImage(wallpaper.marked ? #imageLiteral(resourceName: "baseline_star_black"):#imageLiteral(resourceName: "baseline_star_border_black"), for: .normal)
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        
        imageView.backgroundColor = .lightGray
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.isOpaque = true
        contentView.addSubview(imageView)
        
        toggleButton.bounds.size = CGSize(width: 30, height: 30)
        toggleButton.frame.origin = CGPoint(x: frame.width-34, y: frame.height-34)
        toggleButton.tintColor = .white
        toggleButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        contentView.addSubview(toggleButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Objc Methods
    @objc private func toggle() {
        let index = manager.setMarked(!wallpaper.marked, of: wallpaper)
        NotificationCenter.default.post(name: .markStateChanged, object: wallpaper, userInfo: ["index": index, "source": superview!])
        toggleButton.setImage(wallpaper.marked ? #imageLiteral(resourceName: "baseline_star_black"):#imageLiteral(resourceName: "baseline_star_border_black"), for: .normal)
    }
}
