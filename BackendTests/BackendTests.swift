//
//  BackendTests.swift
//  BackendTests
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import XCTest
@testable import Backend

class BackendTests: XCTestCase {
    
    func testFetchImage() {
        measure {
            let g = DispatchGroup()
            let manager = WallpaperManager()
            g.enter()
            manager.refreshWallpapers { success in
                if success {
                    manager.loadFullImage(for: manager.allWallpapers.first!) { image in
                        print(image)
                        g.leave()
                    }
                }
            }
            g.wait()
        }
    }
    
}
