//
//  SPTNewReleases.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTNewReleases: Codable {
    let albums: SPTNRAlbum?
    struct SPTNRAlbum: Codable {
        let href: String?
        let items: [SPTNRItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTNRItem: Codable {
            let album_type: String?
            let artists: [SPTNRArtist]?
            let available_markets: [String]?
            let external_urls: SPTNRURL?
            let href: String?
            let id: String?
            let images: [SPTNRItem]?
            let name: String?
            let type: String?
            let uri: String?
            
            struct SPTNRItem: Codable {
                let href: String?
                let icons: [SPTNRIcon]?
                let id: String?
                let name: String?
                
                
                struct SPTNRIcon: Codable {
                    let height: Int?
                    let url: String?
                    let width: Int?
                }
            }
            
            struct SPTNRArtist: Codable {
                let external_urls: SPTNRURL?
                let href: String?
                let id: String?
                let name: String?
                let type: String?
                let uri: String?
            }
            
            struct SPTNRURL: Codable {
                let spotify: String?
            }
        }
    }
    
}
