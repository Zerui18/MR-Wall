//
//  UIViewController+Alert.swift
//  MR Wall
//
//  Created by Chen Zerui on 6/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
