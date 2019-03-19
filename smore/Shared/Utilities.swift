//
//  Utilities.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum Utilities {
    /// for the optional width arg, pass in the width in points, not in pixess
    static func highResImage(
        from url: String?,
        width: Int = Int(UIScreen.main.bounds.width * 0.75)) -> URL?
    {
        if let url = url {
            let scaledWidth = width * Int(UIScreen.main.scale)
            let replaceOne = url.replacingOccurrences(of: "{w}", with: "\(scaledWidth)")
            let replaceTwo = replaceOne.replacingOccurrences(of: "{h}", with: "\(scaledWidth)")
            if let resultURL = URL(string: replaceTwo) {
                return resultURL
            }
        }
        return nil
    }
    
    static func timeIntervalToReg(from interval: TimeInterval) -> String {
        let minute = String(Int(interval) / 60)
        var seconds = String(Int(interval) % 60)
        if seconds.count == 1 {seconds = "0" + seconds}
        return minute + ":" + seconds
    }
}
