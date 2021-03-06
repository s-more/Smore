//
//  SPTArtistTopTracks.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTArtistTopTracksResponse: Codable {
    let tracks: [SPTTrack]?
    
    struct SPTTrack: Codable {
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
            let type: String?
            let uri: String?
            
            struct SPTImage: Codable {
                let height: Int?
                let url: String?
                let width: Int?
            }
        }
        
        struct SPTArtist: Codable {
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let name: String?
            let type: String?
            let uri: String?
        }
        struct SPTID: Codable {
            let isrc: String?
        }
        
        struct SPTURL: Codable {
            let spotify: String?
        }
        
    }
}
