//
//  PlayerViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlayerViewModel: NSObject {
    var isDismissing: Bool
    var horizontalPosition: CGFloat
    
    override init() {
        isDismissing = false
        horizontalPosition = 0
        super.init()
    }

}
