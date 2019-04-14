//
//  SPTPlaylistResponse.swift
//  smore
//
//  Created by Colin Williamson on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTPlaylistResponse: Codable {
    let collaborative: Bool?
    let description: String?
    let external_urls: SPTURL?
    let followers: SPTFollowers?
    let href: String?
    let id: String?
    let images: [SPTImage]?
    let name: String?
    let owner: SPTOwner?
    let primary_color: String?
    let `public`: Bool?
    let snapshot_id: String?
    let tracks: SPTTrack?
    let type: String?
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
    
    struct SPTOwner: Codable {
        let display_name: String?
        let external_urls: SPTURL?
        let href: String?
        let id: String?
        let type: String?
        let uri: String?
    }
    
    struct SPTTrack: Codable {
        let href: String?
        let items: [SPTPlaylistTrack]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTPlaylistTrack: Codable {
            let added_at: Date?
            let added_by: SPTUser?
            let is_local: Bool?
            let primary_color: String?
            let track: SPTTrackItem?
            let video_thumbnail: SPTThumb?
            
            struct SPTUser: Codable {
                let external_urls: SPTURL?
                let href: String?
                let id: String?
                let type: String?
                let uri: String?
            }
            
            struct SPTTrackItem: Codable {
                let album: SPTTrackAlbum?
                let artists: [SPTTrackArtist]?
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
                
                struct SPTTrackAlbum: Codable {
                    let album_type: String?
                    let artists: [SPTTrackArtist]?
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
                }
                
                struct SPTTrackArtist: Codable {
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
            }
            
            struct SPTThumb: Codable {
                let url: String?
            }
        }
    }
}
