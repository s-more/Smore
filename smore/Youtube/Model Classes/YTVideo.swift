//
//  YTSong.swift
//  smore
//
//  Created by sin on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class YTVideo: Song {
    var name: String
    var genre: String
    var imageLink: URL?
    var originalImageLink: String?
    var id: String
    var playableString: String
    var artistName: String
    var streamingService: StreamingService = .youtube
    var trackNumber: Int
    var duration: TimeInterval
    
    init(resource: YTSearchResults.YTResource) {
        name = resource.snippet.title
        genre = ""
        imageLink = resource.snippet.thumbnails.medium.url
        originalImageLink = resource.snippet.thumbnails.medium.url.absoluteString
        id = "" // TODO
        playableString = "" // TODO
        artistName = resource.snippet.channelTitle
        trackNumber = 0
        duration = 1
    }
}
