//
//  CombinedPlaylist.swift
//  smore
//
//  Created by Jing Wei Li on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class CombinedPlaylist: Playlist {
    var id: String
    var name: String
    var curatorName: String
    var playableString: String
    var originalImageLink: String?
    var imageLink: URL?
    var songs: [Song]
    var streamingService: StreamingService
    var description: String?
    
    init(name: String, imageLink: URL?, description: String?, songs: [Song]) {
        self.name = name
        self.description = description
        self.imageLink = imageLink
        originalImageLink = imageLink?.absoluteString
        streamingService = .combined
        self.songs = songs
        id = "usergenerated\(UserDefaults.newestUserPlaylistID())"
        curatorName = "You"
        playableString = "-1"
    }
    
    init(playlistEntity: PlaylistEntity) {
        id = playlistEntity.id ?? ""
        name = playlistEntity.name ?? ""
        curatorName = playlistEntity.curatorName ?? ""
        playableString = playlistEntity.playableString ?? ""
        imageLink = playlistEntity.imageLink
        originalImageLink = playlistEntity.originalImageLink
        description = playlistEntity.editorDescription
        songs = (playlistEntity.songs?.array as? [SongEntity])?
            .compactMap { SongEntity.standardSong(from: $0) }
            ?? []
        streamingService = .combined
    }
    
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard songs.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
        error(NSError(domain: "This function should not be called as it's a user defined playlist stored locally", code: 0, userInfo: nil))
    }
    
    
}
