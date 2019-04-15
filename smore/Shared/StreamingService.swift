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
    case combined = 4
    
    var icon: UIImage? {
        switch self {
        case .appleMusic:
            return UIImage(named: "appleLogo")
        case .spotify:
            return UIImage(named: "spotLogo")
        case .youtube:
            return UIImage(named: "youtubeIcon")
        case .combined:
            return UIImage(named: "mixedPlaylistIcon")
        default:
            return nil
        }
        
    }
}


