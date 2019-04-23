//
//  FeatureFlags.swift
//  smore
//
//  Created by Jing Wei Li on 4/23/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

enum FeatureFlags {
    private static let appleMusicEnabledKey = "appleMusicEnabled"
    private static let spotifyEnabledKey = "spotifyEnabled"
    private static let youtubeEnabledKey = "youtubeEnabled"
    
    static func setAppleMusicEnabled(_ enabled: Bool) {
//        UIApplication.shared.open(
//            URL(string: UIApplication.openSettingsURLString)!,
//            options: Dictionary(uniqueKeysWithValues: [:].map { (UIApplication.OpenExternalURLOptionsKey(rawValue: $0), $1) }),
//            completionHandler: nil)
        UserDefaults.standard.set(enabled, forKey: appleMusicEnabledKey)
    }
    
    static func setSpotifyEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: spotifyEnabledKey)
    }
    
    static func setYoutubeEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: youtubeEnabledKey)
    }
    
    static var appleMusicEnabled: Bool {
        return UserDefaults.standard.bool(forKey: appleMusicEnabledKey)
    }
    
    static var spotifyEnabled: Bool {
        return UserDefaults.standard.bool(forKey: spotifyEnabledKey)
    }
    
    static var youtubeEnabled: Bool {
        return UserDefaults.standard.bool(forKey: youtubeEnabledKey)
    }
    
    static var atLeastOneServiceEnabled: Bool {
        let services: [StreamingService] = [.appleMusic, .spotify, .youtube]
        return services
            .map { $0.isServiceEnabled }
            .filter { $0 == true }
            .count > 0
    }
}
