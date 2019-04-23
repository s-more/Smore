//
//  APMRecommendationResponse.swift
//  smore
//
//  Created by Jing Wei Li on 4/21/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

public struct APMRecommendationResponse: Codable {
    let data: [APMRecommendationWrapperData]
    
    struct APMRecommendationWrapperData: Codable {
        let id: String
        let type: String
        let attributes: APMRecommendationDataAttributes
        let href: String?
        let relationships: APMRecommendationRelationships
        
        struct APMRecommendationDataAttributes: Codable {
            let isGroupRecommendation: Bool
            let title: APMRecommendationTitle
            let resourceTypes: [String]
            let nextUpdateDate: Date
            
            struct APMRecommendationTitle: Codable {
                let stringForDisplay: String
            }
            
        }
        
        struct APMRecommendationRelationships: Codable {
            let contents: APMRecommendationContents?
            
            struct APMRecommendationContents: Codable {
                let data: [APMRecommendationData]
                
                struct APMRecommendationData: Codable {
                    let id: String
                    let type: String
                    let href: String?
                    let attributes: APMRecommendationAttributes
                    
                    struct APMRecommendationAttributes: Codable {
                        //shared
                        let playParams: APMPlayParams
                        let name: String
                        let url: URL
                        let artwork: APMArtwork?
                        
                        // playlists
                        let curatorName: String?
                        let lastModifiedDate: Date?
                        let playlistType: String?
                        let description: APMEditorialNotes?
                        
                        // albums
                        let artistName: String?
                        let isSingle: Bool?
                        let isComplete: Bool?
                        let genreNames: [String]?
                        let trackCount: Int?
                        let isMasteredForItunes: Bool?
                        let releaseDate: String?
                        let recordLabel: String?
                        let copyright: String?
                        let contentRating: String?
                        let editorialNotes: APMEditorialNotes?
                        
                        struct APMPlayParams: Codable {
                            let id: String
                            let kind: String
                            let versionHash: String?
                        }
                        
                        struct APMEditorialNotes: Codable {
                            let standard: String?
                            let short: String?
                        }
                        
                        struct APMArtwork: Codable {
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
                    }
                }
            }
            
            // insert
        }
    }
}
