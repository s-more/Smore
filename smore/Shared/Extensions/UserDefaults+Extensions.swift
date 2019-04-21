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
    
    static func saveUserToken(_ token: String) {
        standard.set(token, forKey: userTokenKey)
    }
    
    static func getUserToken() -> String {
        return standard.string(forKey: userTokenKey) ?? ""
    }
    
}
