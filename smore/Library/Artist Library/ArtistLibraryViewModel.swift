//
//  LibraryViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ArtistLibraryViewModel: LibraryViewModel {
    let artist: Artist
    
    /// init from an Artist.
    init(artist: Artist) {
        self.artist = artist
        super.init()
    }
    
    override var highResImageURL: URL? {
        return Utilities.highResImage(from: artist.originalImageLink)
    }
    
    override var hideFollowButton: Bool {
        return false
    }
    
    override var disableFollowButton: Bool {
        return APMArtistEntity.doesArtistExist(artist: artist)
    }
    
    override var titleText: String {
        return artist.name
    }
    
    override var details: String {
        let items = [
            "\(fetchedPlaylists.count) playlists",
            "\(fetchedAlbums.count + fetchedSingles.count) albums",
            "\(fetchedSongs.count) songs"
        ]
        return items.joined(separator: " · ")
    }
    
    override func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        AppleMusicAPI.searchCatalog(
            with: artist.name,
            types: [.albums, .playlists, .songs],
            limit: 20,
            success: { [weak self] data in
                if let rawAlbums = data.albums?.data {
                    let albums =  rawAlbums.map { APMAlbum(response: $0) }
                    self?.fetchedAlbums = albums.filter { !$0.isSingle }
                    self?.fetchedSingles = albums.filter { $0.isSingle }
                }
                if let rawPlaylists = data.playlists?.data {
                    self?.fetchedPlaylists = rawPlaylists.map { APMPlaylist(searchResponse: $0) }
                }
                if let rawSongs = data.songs?.data {
                    self?.fetchedSongs = rawSongs.map { APMSong(searchResponse: $0) }
                }
                if let strongSelf = self {
                    strongSelf.viewControllers.removeAll()
                    if !strongSelf.fetchedPlaylists.isEmpty {
                        strongSelf.viewControllers.append(LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists))
                    }
                    if !strongSelf.fetchedAlbums.isEmpty {
                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedAlbums, buttonBarTitle: "Albums"))
                    }
                    if !strongSelf.fetchedSingles.isEmpty {
                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedSingles, buttonBarTitle: "Singles"))
                    }
                    if !strongSelf.fetchedSongs.isEmpty {
                        strongSelf.viewControllers.append(LibrarySongTableViewController(songs: strongSelf.fetchedSongs))
                    }
                }
                completion()
            }, error: { err in
                error(err)
            })
    }
    
    override func followButtonTapped() {
        if !APMArtistEntity.doesArtistExist(artist: artist) {
            APMArtistEntity.createArtists(from: [artist])
        }
    }
}
