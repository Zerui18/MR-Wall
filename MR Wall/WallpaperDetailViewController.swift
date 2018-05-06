//
//  WallpaperDetailViewController.swift
//  MR Wall
//
//  Created by Chen Zerui on 6/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import Backend

class WallpaperDetailViewController: UIViewController, UIScrollViewDelegate{
    
    static func `init`(wallpaper: Wallpaper)-> WallpaperDetailViewController {
        let ctr = WallpaperDetailViewController()
        ctr.wallpaper = wallpaper
        return ctr
    }
    
    private var wallpaper: Wallpaper!
    
    let scrollView = UIScrollView(frame: .zero)
    let imageView = UIImageView(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "??pt × ??pt"
        setupUI()
        loadImage()
    }
    
    private func setupUI() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.backgroundColor = .white
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(activityIndicator)
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let doubTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        doubTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubTap)
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(saveImage(_:)))
        view.addGestureRecognizer(hold)
    }
    
    @objc private func loadImage() {
        guard !activityIndicator.isAnimating && imageView.image == nil else {
            return
        }
        activityIndicator.startAnimating()
        
        manager.loadFullImage(for: wallpaper) { (image) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let image = image {
                    self.imageView.image = image
                    self.title = "\(Int(self.wallpaper.width))pt × \(Int(self.wallpaper.height))pt"
                }
                else {
                    self.alert(title: "Error", message: "Failed to load full image.")
                }
            }
        }
    }
    
    @objc private func saveImage(_ sender: UILongPressGestureRecognizer) {
        guard !activityIndicator.isAnimating && sender.state == .began,
            let image = imageView.image else {
            return
        }
        
        let alert = UIAlertController(title: "Save Image", message: "Save this image to photo album?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
