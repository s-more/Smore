//
//  Utilities.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum Utilities {
    static func highResImage(from url: String?) -> URL? {
        if let url = url {
            let availableWidth = Int(UIScreen.main.bounds.width * UIScreen.main.scale * 0.75)
            let replaceOne = url.replacingOccurrences(of: "{w}", with: "\(availableWidth)")
            let replaceTwo = replaceOne.replacingOccurrences(of: "{h}", with: "\(availableWidth)")
            if let resultURL = URL(string: replaceTwo) {
                return resultURL
            }
        }
        return nil
    }
}
