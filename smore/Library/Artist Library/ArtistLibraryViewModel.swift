//
//  LibraryViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class ArtistLibraryViewModel: NSObject {
    let artist: Artist
    var fetchedAlbums: [Album] = []
    var fetchedPlaylists: [Playlist] = []
    var fetchedSongs: [Song] = []
    
    var isDataReady = false
    
    /// init from an Artist.
    init(artist: Artist) {
        self.artist = artist
        super.init()
    }
    
    func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        AppleMusicAPI.searchCatalog(
            with: artist.name,
            types: [.albums, .playlists, .songs],
            limit: 20,
            success: { [weak self] data in
                if let rawAlbums = data.albums?.data {
                    self?.fetchedAlbums = rawAlbums.map { APMAlbum(response: $0) }
                }
                if let rawPlaylists = data.playlists?.data {
                    self?.fetchedPlaylists = rawPlaylists.map { APMPlaylist(searchResponse: $0) }
                }
                if let rawSongs = data.songs?.data {
                    self?.fetchedSongs = rawSongs.map { APMSong(searchResponse: $0) }
                }
                completion()
            }, error: { err in
                error(err)
            })
    }
    
}
