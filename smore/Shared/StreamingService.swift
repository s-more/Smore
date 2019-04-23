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
            return UIImage(named: "appleLogo2")
        case .spotify:
            return UIImage(named: "spotifyLogo2") //spotLogo
        case .youtube:
            return UIImage(named: "youtubeLogo2") //youtubeIcon
        case .combined:
            return UIImage(named: "mixedPlaylistIcon")
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .appleMusic:
            return "Apple Music"
        case .spotify:
            return "Spotify"
        case .youtube:
            return "YouTube"
        case .none:
            return "None"
        case .combined:
            return "Combined"
        }
    }
    
    var isServiceEnabled: Bool {
        switch self {
        case .appleMusic:
            return FeatureFlags.appleMusicEnabled
        case .spotify:
            return FeatureFlags.spotifyEnabled
        case .youtube:
            return FeatureFlags.youtubeEnabled
        default: return false
        }
    }
    
    func toggleServiceEnabled() {
        let enabled = isServiceEnabled
        switch self {
        case .appleMusic:
            FeatureFlags.setAppleMusicEnabled(!enabled)
        case .spotify:
            FeatureFlags.setSpotifyEnabled(!enabled)
        case .youtube:
            FeatureFlags.setYoutubeEnabled(!enabled)
        default: break
        }
    }
}


