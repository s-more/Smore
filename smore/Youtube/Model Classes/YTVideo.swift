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
    var genre: String = ""
    var imageLink: URL?
    var originalImageLink: String?
    var id: String
    var playableString: String
    var artistName: String
    var streamingService: StreamingService = .youtube
    var trackNumber: Int = 0
    var duration: TimeInterval = 1
    
    init(resource: YTSearchResults.YTResource) {
        name = resource.snippet.title
        imageLink = resource.snippet.thumbnails.default.url
        originalImageLink = resource.snippet.thumbnails.default.url.absoluteString
        id = "" // TODO
        playableString = "" // TODO
        artistName = resource.snippet.channelTitle
    }
}
