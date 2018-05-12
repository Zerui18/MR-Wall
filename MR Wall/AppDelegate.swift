//
//  AppDelegate.swift
//  MR Wall
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import Nuke
import Backend

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let paths = [\WallpaperManager.allWallpapers, \WallpaperManager.markedWallappers]
        let items = [UITabBarItem(title: "All", image: nil, tag: 0), UITabBarItem(title: "Marked", image: nil, tag: 0)]
        let rootVC = UITabBarController()
        rootVC.viewControllers = zip(paths, items).map {
            let vc = WallpaperCollectionViewController(sourceRef: $0)
            vc.tabBarItem = $1
            return UINavigationController(rootViewController: vc)
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

