//
//  UIImage+Extensions.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageFrom(color: UIColor, size: CGSize = CGSize(width: 500, height: 500)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
