//
//  Array+InsertionPoint.swift
//  Backend
//
//  Created by Chen Zerui on 10/5/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    
    /// Find insertion index for new element with binary search
    private func insertionPoint(of element: Element)-> Int {
        if isEmpty {
            return 0
        }
        
        var lowerbound = 0, upperbound = count
        
        while lowerbound < upperbound {
            let mid = lowerbound + (upperbound-lowerbound)/2
            
            if self[mid] > element {
                upperbound = mid
            }
            else if self[mid] < element {
                lowerbound = mid + 1
            }
            else {
                break
            }
        }
        
        return upperbound
    }
    
    /**
     Insert a new element into a sorted array, maintaining the sorted order.
     - returns: the index of the new element
     */
    mutating func insertSorted(_ element: Element)-> Int{
        let index = insertionPoint(of: element)
        insert(element, at: index)
        return index
    }
    
}
