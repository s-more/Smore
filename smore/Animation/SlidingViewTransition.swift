//
//  SlidingViewTransition.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 8/14/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

/**
 * Credit to https://stackoverflow.com/questions/22940940/transition-navigation-bar-title
 */
enum SlidingViewTransition {
    
    static let up: CATransition = {
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()
    
    static let down: CATransition = {
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()
    
}
