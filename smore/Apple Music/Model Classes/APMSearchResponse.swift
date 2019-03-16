//
//  APMSearchResponse.swift
//  smore
//
//  Created by Jing Wei Li on 2/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct APMSearch: Codable {
    let results: APMSearchResults
    
    struct APMSearchResults: Codable {
        let artists: APMSearchArtists?
        let albums: APMSearchAlbums?
        let playlists: APMSearchPlaylists?
        let songs: APMSearchSongs?
        
        struct APMSearchArtists: Codable {
            let href: String
            let data: [APMSearchArtistsData]
            
            struct APMSearchArtistsData: Codable {
                let id: String
                let type: String
                let href: String
                let attributes: APMSearchArtistAttributes
                let relationships: APMSearchArtistRelationships
                
                struct APMSearchArtistAttributes: Codable {
                    let url: URL
                    let name: String
                    let genreNames: [String]
                }
                
                struct APMSearchArtistRelationships: Codable {
                    let albums: APMSearchArtistRelAlbums
                    
                    struct APMSearchArtistRelAlbums: Codable {
                        let data: [APMSearchArtistRelAlbumData]
                        let href: String
                        let next: String?
                        
                        struct APMSearchArtistRelAlbumData: Codable {
                            let id: String
                            let type: String
                            let href: String
                            let attributes: APMAlbumAttributes?
                            
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
                        }
                    }
                }
            }
        }
        
        struct APMSearchAlbums: Codable {
            let href: String
            let next: String?
            let data: [APMAlbumData]
            
            struct APMAlbumData: Codable {
                let id: String
                let type: String
                let href: String
                let attributes: APMAlbumAttributes
                
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
            }
        }
        
        struct APMSearchPlaylists: Codable {
            let href: String
            let data: [APMPlaylists]
            
            struct APMPlaylists: Codable {
                let id: String
                let type: String
                let href: String
                let attributes: APMPlaylistAttributes
                
                struct APMPlaylistAttributes: Codable {
                    let artwork: APMPlaylistArtwork?
                    let lastModifiedDate: Date?
                    let playParams: APMPlaylistsPlayParams?
                    let url: URL
                    let name: String
                    let curatorName: String?
                    let playlistType: String
                    
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
            }
        }
        
        struct APMSearchSongs: Codable {
            let href: String
            let next: String?
            let data: [APMSongData]
            
            struct APMSongData: Codable {
                let id: String
                let type: String
                let href: String
                let attributes: APMSongAttributes
                
                struct APMSongAttributes: Codable {
                    let previews: [APMSongPreviews]
                    let artwork: APMSongArtwork?
                    let artistName: String
                    let url: URL
                    let discNumber: Int?
                    let genreNames: [String]
                    let durationInMillis: Int
                    let releaseDate: String
                    let name: String
                    let isrc: String
                    let albumName: String
                    let playParams: APMSongPlayParams?
                    let trackNumber: Int
                    let composerName: String?
                    
                    struct APMSongPreviews: Codable {
                        let url: URL
                    }
                    
                    struct APMSongArtwork: Codable {
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
                    
                    struct APMSongPlayParams: Codable {
                        let id: String
                        let kind: String
                    }
                }
            }
        }
    }
}
