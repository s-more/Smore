//
//  CAGradientLayer+BackgroundColor.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    class func gradient(colors: [UIColor],
                        frame: CGRect,
                        start: CGPoint = CGPoint(x: 0, y: 0),
                        end: CGPoint = CGPoint(x: 1, y: 1)) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = start
        gradient.endPoint = end
        return gradient
    }
}
