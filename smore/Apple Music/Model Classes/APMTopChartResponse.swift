//
//  APMTopChartResponse.swift
//  smore
//
//  Created by Jing Wei Li on 2/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 We are not implementing music videos for sure.
 ```
 // not implemented:
 case musicVideos = "music-videos"
 ```
 */
struct APMTopChartResponse: Codable {
    let results: APMTopChartResonseResults
    
    struct APMTopChartResonseResults: Codable {
        let albums: [APMAlbum]?
        let songs: [APMSong]?
        
        struct APMAlbum: Codable {
            let name: String
            let chart: String
            let href: String
            let next: String
            let data: [APMAlbumData]
            
            struct APMAlbumData: Codable {
                let id: String
                let type: String
                let href: String
                let attributes: APMAlbumAttributes
                
                struct APMAlbumAttributes: Codable {
                    let artwork: APMAlbumArtwork
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
                    let copyright: String
                    let playParams: APMAlbumPlayParams
                    let editorialNotes: APMAlbumEditorialNotes?
                    
                    struct APMAlbumArtwork: Codable {
                        let width: Int
                        let height: Int
                        let url: String
                        let bgColor: String
                        let textColor1: String
                        let textColor2: String
                        let textColor3: String
                        let textColor4: String
                        
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
                        let short: String
                    }

                }
            }
        }
        
        struct APMSong: Codable {
            let name: String
            let chart: String
            let href: String
            let next: String
            let data: [APMSongData]
            
            struct APMSongData: Codable {
                let id: String
                let type: String
                let href: URL
                let attributes: APMSongAttributes
                
                struct APMSongAttributes: Codable {
                    let previews: [APMSongPreview]
                    let artwork: APMSongArtwork
                    let artistName: String
                    let url: URL
                    let discNumber: Int
                    let genreNames: [String]
                    let durationInMillis: Int
                    let releaseDate: String
                    let name: String
                    let isrc: String
                    let albumName: String
                    let playParams: APMSongPlayParams
                    let trackNumber: Int
                    let composerName: String?
                    
                    struct APMSongPreview: Codable {
                        let url: URL
                    }
                    
                    struct APMSongArtwork: Codable {
                        let width: Int
                        let height: Int
                        let url: String
                        let bgColor: String
                        let textColor1: String
                        let textColor2: String
                        let textColor3: String
                        let textColor4: String
                        
                        func artworkImageURL(width: Int = 500, height: Int = 500) -> URL {
                            var validDimensions = url.replacingOccurrences(of: "{w}", with: "\(width)")
                            validDimensions = validDimensions.replacingOccurrences(of: "{h}", with: "\(height)")
                            return URL(string: validDimensions)!
                        }
                    }
                    
                    struct APMSongPlayParams: Codable {
                        let id: String
                        let kind: String
                    }
                }
            }
        }
    }
}
