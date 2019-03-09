//
//  LibraryViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ArtistLibraryViewModel: NSObject {
    let artist: Artist
    var fetchedAlbums: [Album] = []
    var fetchedPlaylists: [Playlist] = []
    var fetchedSongs: [Song] = []
    
    var isDataReady = false
    
    var viewControllers: [UITableViewController & ScrollHeightCalculable] = [
        LibraryPlaylistTableViewController()
    ]
    
    /// init from an Artist.
    init(artist: Artist) {
        self.artist = artist
        super.init()
    }
    
    var details: String {
        let items = [
            "\(fetchedAlbums.count) albums",
            "\(fetchedPlaylists.count) playlists",
            "\(fetchedSongs.count) songs"
        ]
        return items.joined(separator: " - ")
    }
    
    func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        isDataReady = false
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
                self?.isDataReady = true
                if let strongSelf = self {
                    strongSelf.viewControllers = [
                        LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists),
                        LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists)
                    ]
                }
                completion()
            }, error: { err in
                error(err)
            })
    }
    
}
