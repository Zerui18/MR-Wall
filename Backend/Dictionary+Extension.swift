//
//  Dictionary+Extension.swift
//  Backend
//
//  Created by Chen Zerui on 5/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    
    subscript(paths: String...)-> Any? {
        var it = paths.makeIterator()
        
        var value: Any? = self[it.next()!]
        
        while value != nil, let id = it.next() {
            value = (value as? Dictionary)?[id]
        }
        
        return value
    }
    
}
