//
//  SPTPlaylist.swift
//  smore
//
//  Created by Colin Williamson on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class SPTPlaylist: Playlist {
    var id: String
    var name: String
    var curatorName: String
    var playableString: String
    var imageLink: URL?
    var songs: [Song] = []
    var originalImageLink: String?
    var streamingService: StreamingService = .spotify
    var description: String?
    
    init(searchResponse: SPTPlaylistResponse) {
        id = searchResponse.id ?? ""
        name = searchResponse.name ?? ""
        curatorName = searchResponse.owner?.display_name ?? "Unknown Curator"
        playableString = searchResponse.uri ?? ""
        imageLink = URL(string: searchResponse.images?.first?.url ?? "")
        originalImageLink = searchResponse.images?.first?.url ?? ""
        description = searchResponse.description ?? ""
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
    
    init(playlistSearchResponse: SPTSearchResponse.SPTPlaylist.SPTPlaylistItem) {
        id = playlistSearchResponse.id ?? ""
        name = playlistSearchResponse.name ?? ""
        curatorName = playlistSearchResponse.owner?.display_name ?? ""
        playableString = playlistSearchResponse.uri ?? ""
        imageLink = URL(string: playlistSearchResponse.images?.first?.url ?? "")
        originalImageLink = playlistSearchResponse.images?.first?.url ?? ""
        description = playlistSearchResponse.name ?? ""
    }
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard songs.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
        let SPTToken = SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? ""
        SpotifyAPI.getPlaylists(token: SPTToken, playlistID: id, completion: { [weak self] data in
            self?.songs = data.tracks?.items?.map { SPTSong(trackData: $0) } ?? []
            completion()
            }, error: { err in
                error(err)
        })
    }
}
