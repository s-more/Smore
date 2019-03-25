//
//  SPTAlbum.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTAlbum: Codable {
    let album_type: String?
    let artists: [SPTArtist]?
    let available_markets: [String]?
    let copyrights: [SPTCopyright]?
    let external_ids: SPTID?
    let external_urls: SPTURL?
    let genres: [String?]
    let href: String?
    let id: String?
    let images: [SPTImage]?
    let name: String?
    let popularity: Int?
    let release_date: String?
    let release_date_precision: String?
    let tracks: SPTTrack?
    let type: String?
    let uri: String?
    
    
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
        let upc: String?
    }

    struct SPTURL: Codable {
        let spotify: String?
    }
    
    struct SPTCopyright: Codable {
        let text: String?
        let type: String?
    }
    
    struct SPTTrack: Codable {
        let href: String?
        let items: [SPTItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTItem: Codable {
            let artists: [SPTArtist]?
            let available_markets: [String]?
            let disc_number: Int?
            let duration_ms: Int?
            let explicit: Bool?
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let name: String?
            let preview_url: String?
            let track_number: Int?
            let type: String?
            let uri: String?
        }
    }
}
