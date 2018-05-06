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
    
    private let imageView = UIImageView(frame: .zero)
    
    var wallpaper: Wallpaper! {
        didSet {
            Nuke.loadImage(with: wallpaper.getImageURL(for: CGSize(width: 400, height: 400)), options: ImageLoadingOptions(transition: .fadeIn(duration: 0.3333)), into: imageView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
