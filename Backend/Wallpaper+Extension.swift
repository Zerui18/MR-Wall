//
//  Wallpaper+Extension.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

extension Wallpaper {
    
    public enum ResizeOption: String {
        case fit, fitInside
    }
    
    public var size: CGSize? {
        get {
            guard width != 0 && height != 0 else {
                return nil
            }
            return CGSize(width: width, height: height)
        }
        set {
            
            width = Double(newValue?.width ?? 0)
            height = Double(newValue?.height ?? 0)
        }
    }
    
    @inline(__always)
    public func getImageURL(for size: CGSize, resizeOption: ResizeOption = .fit)-> URL {
        let path = fileURL!.replacingOccurrences(of: "http:/", with: "").replacingOccurrences(of: ".mwa", with: "")
        return URL(string: "http://imangazo.mrcdn.info\(path)/phone_\(size.width)_\(size.height)_\(resizeOption.rawValue).jpg")!
    }
    
}
