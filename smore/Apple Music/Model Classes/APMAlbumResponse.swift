//
//  APMAlbumResponse.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMAlbumResponse: Codable {
    let data: [APMAlbumData]
    
    struct APMAlbumData: Codable {
        let id: String
        let type: String
        let href: String
        let attributes: APMAlbumAttributes
        let relationships: APMAlbumRelationships
        
        struct APMAlbumAttributes: Codable {
            let artwork: APMAlbumArtwork?
            let artistName: String
            let isSingle: Bool
            let url: URL
            let isComplete: Bool
            let genreNames: [String]
            let trackCount: Int
            let isMasteredForItunes: Bool
            let releaseDate: String
            let name: String
            let recordLabel: String
            let copyright: String?
            let playParams: APMAlbumPlayParams?
            let editorialNotes: APMAlbumEditorialNotes?
            
            struct APMAlbumArtwork: Codable {
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
            
            struct APMAlbumPlayParams: Codable {
                let id: String
                let kind: String
            }
            
            struct APMAlbumEditorialNotes: Codable {
                let standard: String?
                let short: String?
            }
        }
        
        struct APMAlbumRelationships: Codable {
            let artists: APMAlbumArtists
            let tracks: APMAlbumTrack
            
            struct APMAlbumArtists: Codable {
                let data: [APMAlbumArtistData]
                let href: String
        
                struct APMAlbumArtistData: Codable {
                    let id: String
                    let type: String
                    let href: String
                }
            }
            
            struct APMAlbumTrack: Codable {
                let data: [APMAlbumTrackData]
                let href: String
                
                struct APMAlbumTrackData: Codable {
                    let attributes: APMTrackAttribute
                    let href: String
                    let id: String
                    let type: String
                    
                    struct APMTrackAttribute: Codable  {
                        let artistName: String
                        let artwork: APMTrackArtwork?
                        let discNumber: Int?
                        let durationInMillis: Int
                        let genreNames: [String]
                        let isrc: String
                        let name: String
                        let playParams: APMTrackPlayParams?
                        let previews: [APMTrackPreview]
                        let releaseDate: String
                        let trackNumber: Int
                        let url: URL
                        let composerName: String?
                        
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
