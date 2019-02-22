//
//  Array+RemoveDuplicates.swift
//  smore
//
//  Created by Jing Wei Li on 2/21/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

extension Array where Element: Equatable & Hashable {
    
    /// Removes duplicates while preserving order.
    func duplicatesRemoved() -> [Element] {
        var set: Set<Element> = Set()
        return self.reduce([], { temp, next in
            if !set.contains(next) {
                set.insert(next)
                return temp + [next]
            }
            return temp
        })
    }
}
