//
//  StreamingService.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum StreamingService: Int {
    case appleMusic = 0
    case spotify = 1
    case youtube = 2
    case none = 3
    
    var icon: UIImage? {
        switch self {
        case .appleMusic:
            return UIImage(named: "appleLogo")
        default:
            return nil
        }
        
    }
}


