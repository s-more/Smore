//
//  SPTRecArtistResponse.swift
//  smore
//
//  Created by Vignesh Babu on 4/23/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTRecArtistResponse: Codable {
    let tracks: [SPTRecTracks]?
    let seeds: [SPTRecSeeds]?
    
    struct SPTRecTracks: Codable {
        let album: SPTAlbum?
        let artists: [SPTArtist]?
        let available_markets: [String]?
        let disc_number: Int?
        let duration_ms: Int?
        let explicit: Bool?
        let external_ids: SPTID?
        let external_urls: SPTURL?
        let href: String?
        let id: String?
        let is_local: Bool?
        let name: String?
        let popularity: Int?
        let preview_url: String?
        let track_number: Int?
        let type: String?
        let uri: String?
        
        struct SPTAlbum: Codable {
            let album_type: String?
            let artists: [SPTArtist]?
            let available_markets: [String]?
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let images: [SPTImage]?
            let name: String?
            let release_date: String?
            let release_date_precision: String?
            let total_tracks: Int?
            let type: String?
            let uri: String?
        }
        
        struct SPTArtist: Codable {
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let name: String?
            let type: String?
            let uri: String?
        }
        
        struct SPTImage: Codable {
            let height: Int?
            let url: String?
            let width: Int?
        }
        
        struct SPTID: Codable {
            let isrc: String?
        }
        
        struct SPTURL: Codable {
            let spotify: String?
        }
    }
    
    struct SPTRecSeeds: Codable {
        let initialPoolSize: Int?
        let afterFilteringSize: Int?
        let afterRelinkingSize: Int?
        let id: String?
        let type: String?
        let href: String?
    }
}
