//
//  PlayerState.swift
//  smore
//
//  Created by Jing Wei Li on 3/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

enum PlayerState {
    case playing
    case paused
    case notPlaying
    
    var image: UIImage? {
        switch self {
        case .playing:
            return UIImage(named: "PauseButtonLarge")
        case .paused, .notPlaying:
            return UIImage(named: "PlayButtonLarge")
        }
    }
}
