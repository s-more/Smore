//
//  NSNotification+Player.swift
//  smore
//
//  Created by Jing Wei Li on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let skipToNextQueue = Notification.Name("skipToNextQueue")
    static let skipToPreviousQueue = Notification.Name("skipToPreviousQueue")
}
