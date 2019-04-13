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
    var streamingService: StreamingService = .appleMusic
    var description: String?
    
    init(searchResponse: APMSearch.APMSearchResults.APMSearchPlaylists.APMPlaylists) {
        id = searchResponse.id
        name = searchResponse.attributes.name
        curatorName = searchResponse.attributes.curatorName ?? "Unknown Curator"
        playableString = searchResponse.attributes.playParams?.id ?? ""
        imageLink = searchResponse.attributes.artwork?.artworkImageURL()
        originalImageLink = searchResponse.attributes.artwork?.url
        description = nil
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
    }
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard songs.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        AppleMusicAPI.playlists(with: id, completion: { [weak self] data in
            self?.songs = data.relationships.tracks.data.map { APMSong(trackData: $0) }
            let description = data.attributes.description
            self?.description = description?.standard ?? description?.short
            completion()
        }, error: { err in
            error(err)
        })
    }
}
