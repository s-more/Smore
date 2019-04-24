//
//  APMRecentlyPlayedResponse.swift
//  smore
//
//  Created by Jing Wei Li on 4/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

public struct APMRecentlyPlayedResponse: Codable {
    let next: String?
    let data: [APMRecentlyPlayedResponseData]
    
    struct APMRecentlyPlayedResponseData: Codable {
        let id: String
        let type: String
        let href: String
        let attributes: APMRecentlyPlayedResponseAttributes
        
        struct APMRecentlyPlayedResponseAttributes: Codable {
            // shared by albums and playlists
            let artwork: APMArtwork?
            let playParams: APMPlayParams?
            let url: URL
            let name: String
            
            // Albums
            let artistName: String?
            let isSingle: Bool?
            let isComplete: Bool?
            let genreNames: [String]?
            let trackCount: Int?
            let isMasteredForItunes: Bool?
            let releaseDate: String?
            let recordLabel: String?
            let copyright: String?
            let editorialNotes: APMEditorialNotes?
            
            // Playlists
            let curatorName: String?
            let playlistType: String?
            let description: APMEditorialNotes?
            let lastModifiedDate: Date?
            
            struct APMArtwork: Codable {
                let width: Int
                let height: Int
                let url: String
                let bgColor: String?
                let textColor1: String?
                let textColor2: String?
                let textColor3: String?
                let textColor4: String?
                
                func artworkImageURL(width: Int = 500, height: Int = 500) -> URL {
                    var validDimensions = url.replacingOccurrences(of: "{w}", with: "\(width)")
                    validDimensions = validDimensions.replacingOccurrences(of: "{h}", with: "\(height)")
                    return URL(string: validDimensions)!
                }
            }
            
            struct APMPlayParams: Codable {
                let id: String
                let kind: String
            }
            
            struct APMEditorialNotes: Codable {
                let standard: String?
                let short: String?
            }
        }
    }
}


