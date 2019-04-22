//
//  UserDefaults+Extensions.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let isFirstLaunchIdenfier = "isFirstLaunch-1"
    private static let favGenreKey = "favGenreKey"
    private static let favArtistsKey = "favArtistsKey"
    private static let userPlaylistID = "userDefinedPlaylist"
    private static let userTokenKey = "userTokenKey"
    
    // MARK: - First Launch
    
    class var isFirstLaunch: Bool {
        return !standard.bool(forKey: isFirstLaunchIdenfier)
    }
    
    static func setFirstLaunch() {
        standard.set(true, forKey: isFirstLaunchIdenfier)
    }
    
    // MARK: - Fav Genres and Artists
    static func setFavGenres(with genres: [APMCatalogGenre]) {
        standard.set(genres.map { $0.rawValue }, forKey: favGenreKey)
    }
    
    class var favGenres: [APMCatalogGenre] {
        return
            (standard.array(forKey: favGenreKey) as? [Int])?
            .map { APMCatalogGenre(rawValue: $0) ?? .alternative } ?? []
            //.map { APMCatalogGenre(rawValue: $0)} ?? []
    }
    
    public static func newestUserPlaylistID() -> Int {
        var id = standard.integer(forKey: userPlaylistID)
        id += 1
        standard.set(id, forKey: userPlaylistID)
        return id
    }
    
    // MARK: - User Token
    
    static func saveUserToken(_ token: String) {
        standard.set(token, forKey: userTokenKey)
    }
    
    static func getUserToken() -> String {
        return standard.string(forKey: userTokenKey) ?? ""
    }
    
    // MARK: - Feature Flags
    enum FeatureFlags {
        private static let appleMusicEnabledKey = "appleMusicEnabled"
        private static let spotifyEnabledKey = "spotifyEnabled"
        private static let youtubeEnabledKey = "youtubeEnabled"
        
        static func setAppleMusicEnabled(_ enabled: Bool) {
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
    }
    
}
