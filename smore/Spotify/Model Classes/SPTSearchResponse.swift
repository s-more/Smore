//
//  SPTSearchResponse.swift
//  smore
//
//  Created by Colin Williamson on 3/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTSearchResponse: Codable {
    let albums: SPTAlbum?
    let artists: SPTArtist?
    let tracks: SPTTrack?
    let playlists: SPTPlaylist?
    
    
    struct SPTAlbum: Codable {
        let href: String?
        let items: [SPTAlbumItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTAlbumItem: Codable {
            let album_type: String?
            let artists: [SPTAlbumArtist]
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let images: [SPTImage]?
            let name: String?
            let release_date: String?
            let release_date_precision: String?
            let type: String?
            let uri: String?
            
            struct SPTAlbumArtist: Codable {
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
    
    struct SPTArtist: Codable {
        let href: String?
        let items: [SPTArtistItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTArtistItem: Codable {
            let external_urls: SPTURL?
            let followers: SPTFollowers?
            let genres: [String]?
            let href: String?
            let id: String?
            let images: [SPTImage]?
            let name: String?
            let popularity: Int?
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
        }
    }
    
    struct SPTTrack: Codable {
        let href: String?
        let items: [SPTTrackItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
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
    }
    
    struct SPTPlaylist: Codable {
        let href: String?
        let items: [SPTPlaylistItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTPlaylistItem: Codable {
            let collaborative: Bool?
            let external_urls: SPTURL?
            let href: String?
            let id: String?
            let images: [SPTImage]?
            let name: String?
            let owner: SPTOwner?
            let primary_color: String?
            let `public`: String?
            let snapshot_id: String?
            let tracks: SPTTracks?
            let type: String?
            let uri: String?
            
            struct SPTURL: Codable {
                let spotify: String?
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
            
            struct SPTTracks: Codable {
                let href: String?
                let total: Int?
            }
        }
    }
}
