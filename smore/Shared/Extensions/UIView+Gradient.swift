//
//  UIView+Gradient.swift
//  smore
//
//  Created by Jing Wei Li on 2/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     Add the brown-ish smore gradient to any view.
     ```
     // example
     myButton.addDefaultGradient()
     ```
     */
    func addDefaultGradient() {
        let colors = [
            UIColor(red: 220/255, green: 148/255, blue: 111/255, alpha: 1),
            UIColor(red: 132/255, green: 87/255, blue: 64/255, alpha: 1)
        ]
        layer.insertSublayer(CAGradientLayer.gradient(colors: colors, frame: bounds), at: 0)
    }
    
    func addGradient(colors: [UIColor],
                     start: CGPoint = CGPoint(x: 0, y: 0),
                     end: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradient = CAGradientLayer.gradient(colors: colors, frame: bounds, start: start, end: end)
        layer.insertSublayer(gradient, at: 0)
    }
}
