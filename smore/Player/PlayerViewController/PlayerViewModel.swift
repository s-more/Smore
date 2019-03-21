//
//  PlayerViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum ScrollDirection {
    case left
    case right
    case none
}

class PlayerViewModel: NSObject {
    var isDismissing: Bool
    var horizontalPosition: CGFloat
    var timer: Timer?
    var scrollDirectioon: ScrollDirection = .none
    
    override init() {
        isDismissing = false
        horizontalPosition = 0
        super.init()
    }

}
