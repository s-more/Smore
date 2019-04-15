//
//  SPTTopArtistResponse.swift
//  smore
//
//  Created by Vignesh Babu on 4/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTTopArtistResponse: Codable {
    let items: [SPTTopItem]?
    let total: Int?
    let limit: Int?
    let offset: Int?
    let href: String?
    let previous: String?
    let next: String?
    
    struct SPTTopItem: Codable {
        let external_urls: SPTURL?
        let followers: SPTFollowers?
        let genres: [String]?
        let href: String?
        let id: String?
        let images: [SPTImage]?
        let name: String?
        let popularity: Int?
        let `type`: String?
        let uri: String?
        
        struct SPTURL: Codable {
            let spotify: String?
        }
        
        struct SPTFollowers: Codable {
            let href: String?
            let total: Int?
        }
        
        struct SPTImage: Codable {
            let height: Int?
            let url: String?
            let width: Int?
        }
    }
}
