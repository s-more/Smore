//
//  APMPlaylist.swift
//  smore
//
//  Created by Jing Wei Li on 3/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMPlaylist: Playlist {
    var id: String
    var name: String
    var curatorName: String
    var playableString: String
    var imageLink: URL?
    var songs: [Song] = []
    var originalImageLink: String?
    
    init(searchResponse: APMSearch.APMSearchResults.APMSearchPlaylists.APMPlaylists) {
        id = searchResponse.id
        name = searchResponse.attributes.name
        curatorName = searchResponse.attributes.curatorName ?? "Unknown Curator"
        playableString = searchResponse.attributes.playParams?.id ?? ""
        imageLink = searchResponse.attributes.artwork?.artworkImageURL()
        originalImageLink = searchResponse.attributes.artwork?.url
    }
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        
    }
    
    
}
