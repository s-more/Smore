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
                    self?.fetchedAPMAlbums = albums.filter { !$0.isSingle }
                    self?.fetchedAPMSingles = albums.filter { $0.isSingle }
                }
                if let rawPlaylists = data.playlists?.data {
                    self?.fetchedAPMPlaylists = rawPlaylists.map { APMPlaylist(searchResponse: $0) }
                }
                if let rawSongs = data.songs?.data {
                    self?.fetchedAPMSongs = rawSongs.map { APMSong(searchResponse: $0) }
                }
                let SPTToken = SpotifyRemote.shared.appRemote.connectionParameters.accessToken
                SpotifyAPI.searchCatalog(
                    token: SPTToken ?? "",
                    term: self?.artist.name ?? "",
                    types: [.albums, .playlists, .tracks],
                    limit: 20,
                    success: { [weak self] data in
                        if let rawAlbums = data.albums?.items {
                            let albums =  rawAlbums.map { SPTAlbum(searchAlbumData: $0) }
                            self?.fetchedSPTAlbums = albums.filter { !$0.isSingle }
                            self?.fetchedSPTSingles = albums.filter { $0.isSingle }
                        }
                        if let rawPlaylists = data.playlists?.items {
                            self?.fetchedSPTPlaylists = rawPlaylists.map { SPTPlaylist(playlistSearchResponse: $0) }
                        }
                        if let rawSongs = data.tracks?.items {
                            self?.fetchedSPTSongs = rawSongs.map { SPTSong(searchResponse: $0) }
                        }
                        if let strongSelf = self {
                            self?.fetchedAlbums = (self?.fetchedAPMAlbums ?? []) + (self?.fetchedSPTAlbums ?? [])
                            self?.fetchedSingles = (self?.fetchedAPMSingles ?? []) + (self?.fetchedSPTSingles ?? [])
                            self?.fetchedSongs = (self?.fetchedAPMSongs ?? []) + (self?.fetchedSPTSongs ?? [])
                            self?.fetchedPlaylists = (self?.fetchedAPMPlaylists ?? []) + (self?.fetchedSPTPlaylists ?? [])
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
                            if strongSelf.viewControllers.isEmpty {
                                strongSelf.viewControllers.append(LibraryPlaylistTableViewController())
                            }
                        }
                        completion()
                    }, error: { err in
                        error(err)
                })
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
