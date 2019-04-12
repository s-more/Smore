//
//  YTSearchResponse.swift
//  smore
//
//  Created by sin on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct YTSearchResults: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let prevPageToken: String?
    let regionCode: String
    let pageInfo: YTPageInfo
    let items: [YTResource]
    
    struct YTPageInfo: Codable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    struct YTResource: Codable {
        let kind: String
        let etag: String
        let id: YTResourceInfo
        let snippet: YTResourceData
        
        struct YTResourceInfo: Codable {
            let kind: String
            let playlistId: String
        }
        
        struct YTResourceData: Codable {
            let publishedAt: Date
            let channelId: String
            let title: String
            let description: String
            let thumbnails: YTThumbnailList
            let channelTitle: String
            let liveBroadcastContent: String
            
            struct YTThumbnailList : Codable {
                let `default`: YTThumbnail
                let medium: YTThumbnail
                let high: YTThumbnail
                
                struct YTThumbnail: Codable {
                    let url: URL
                    let width: Int
                    let height: Int
                }
            }
        }
    }
}
