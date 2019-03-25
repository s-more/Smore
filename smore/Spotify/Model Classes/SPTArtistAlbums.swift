//
//  SPTArtistAlbums.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTArtistAlbumsResponse: Codable {
    let href: String?
    let items: [SPTItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    
    struct SPTItem: Codable {
        let album_group: String?
        let album_type: String?
        let artists: [SPTArtists]
        let available_markets: [String]?
        let external_urls: SPTURL?
        let href: String?
        let id: String?
        let images: [SPTImage]?
        let name: String?
        let release_date: String?
        let release_date_precision: String?
        let type: String?
        let uri: String?
        
        struct SPTArtists: Codable {
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let name: String?
            let type: String?
            let uri: String?
        }
        
        struct SPTURL: Codable {
            let spotify: String?
        }
        
        struct SPTImage: Codable {
            let height: Int?
            let url: String?
            let width: Int?
        }
    }
}
