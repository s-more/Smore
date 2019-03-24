//
//  APMPlaylistResponse.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct APMPlaylistResponse: Codable {
    let data: [APMPlaylistData]
    
    struct APMPlaylistData: Codable {
        let attributes: APMPlaylistAttributes
        let href: String
        let id: String
        let relationships: APMPlaylistRelationships
        let type: String
        
        struct APMPlaylistAttributes: Codable {
            let artwork: APMPlaylistArtwork?
            let lastModifiedDate: Date?
            let playParams: APMPlaylistsPlayParams?
            let url: URL
            let name: String
            let curatorName: String?
            let playlistType: String
            let description: APMPlaylistDescription?
            
            struct APMPlaylistDescription: Codable {
                let standard: String?
                let short: String?
            }
            
            struct APMPlaylistArtwork: Codable {
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
            
            struct APMPlaylistsPlayParams: Codable {
                let id: String
                let kind: String
            }
        }
        
        struct APMPlaylistRelationships: Codable {
            let curator: APMPlaylistCurator
            let tracks: APMPlaylistTracks
            
            struct APMPlaylistCurator: Codable {
                let data: [APMPlaylistCuratorData]
                let href: String
                
                struct APMPlaylistCuratorData: Codable {
                    let href: String
                    let id: String
                    let type: String
                }
            }
            
            struct APMPlaylistTracks: Codable {
                let data: [APMPlaylistTrackData]
                
                struct APMPlaylistTrackData: Codable {
                    let attributes: APMPlaylistTrackAttribute
                    let href: String
                    let id: String
                    let type: String
                    
                    struct APMPlaylistTrackAttribute: Codable  {
                        let artistName: String
                        let artwork: APMTrackArtwork?
                        let discNumber: Int?
                        let durationInMillis: Int?
                        let genreNames: [String]
                        let isrc: String
                        let name: String
                        let playParams: APMTrackPlayParams?
                        let previews: [APMTrackPreview]
                        let releaseDate: String
                        let trackNumber: Int
                        let url: URL
                        
                        struct APMTrackArtwork: Codable {
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
                        
                        struct APMTrackPlayParams: Codable {
                            let id: String
                            let kind: String
                        }
                        
                        struct APMTrackPreview: Codable {
                            let url: URL
                        }
                    }
                }
            }
        }
    }
}
