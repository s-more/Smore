//
//  StreamingService.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum StreamingService {
    case appleMusic
    case spotify
    case youtube
    case none
    
    var icon: UIImage? {
        switch self {
        case .appleMusic:
            return UIImage(named: "appleLogo")
        default:
            return nil
        }
        
    }
}


