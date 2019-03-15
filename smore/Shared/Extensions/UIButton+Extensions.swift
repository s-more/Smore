//
//  UIButton+Extensions.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

extension UIButton {
    func addSmoreBoder() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.themeColor.cgColor
        self.layer.borderWidth = 0.75
    }
}
