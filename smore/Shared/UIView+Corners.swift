//
//  UIView+Corners.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addRoundCorners(cornerRadius: CGFloat = 20.0) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
