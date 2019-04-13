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
//                    strongSelf.viewControllers.removeAll()
//                    if !strongSelf.fetchedPlaylists.isEmpty {
//                        strongSelf.viewControllers.append(LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists))
//                    }
//                    if !strongSelf.fetchedAlbums.isEmpty {
//                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedAlbums, buttonBarTitle: "Albums"))
//                    }
//                    if !strongSelf.fetchedSingles.isEmpty {
//                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedSingles, buttonBarTitle: "Singles"))
//                    }
//                    if !strongSelf.fetchedSongs.isEmpty {
//                        strongSelf.viewControllers.append(LibrarySongTableViewController(songs: strongSelf.fetchedSongs))
//                    } 
                completion()
            }, error: { err in
                error(err)
        })
        
        SpotifyAPI.searchCatalog(
            token: "BQAxBRmgVgfUJAV65WN7-pqZg_TFxew2hEQAr39zjXG8A4Ya4IQU3EaJVahCo_Ue1bV9M_x2ULmGAo_xrnZ-HZM-5BBSrDny3tKWAumwuECsosVxvLGBSDSrZQC_mwYaACwDtgZm2WqfhY2knj-19ThcUAysqE3PIgK-UoyYlNNpOE7wG71XgDrgzY7idgde48YXMf-MlGcpN6EJutUHu4e6BwoZFxgV00m2Q-BbU7j7rV7Wk5G5cZG8wdS_09c",
            term: artist.name,
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
        
        
    }
    
    // Spotify Artist Library Search Function
//    override func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
//        SpotifyAPI.searchCatalog(
//            token: "BQAHRUXEjBUv8WZRr7PPMmH7ynPpRFKqjJ5LBIzAE7YNRAk242mEUD57WFDulHqfotgYodqv1OcUuk_UqPNDfPJNnasxZm9Ipc-zlAmc0d3NAuG5wIdcz2TeV7unJmYEhm8PYHy6Bq5WBF3YptkOg2k0E9782q_e7uHFnDffFlx0",
//            term: artist.name,
//            types: [.albums, .playlists, .tracks],
//            limit: 20,
//            success: { [weak self] data in
//                if let rawAlbums = data.albums?.items {
//                    let albums =  rawAlbums.map { SPTAlbum(searchAlbumData: $0) }
//                    self?.fetchedAlbums = albums.filter { !$0.isSingle }
//                    self?.fetchedSingles = albums.filter { $0.isSingle }
//                }
//                if let rawPlaylists = data.playlists?.items {
//                    self?.fetchedPlaylists = rawPlaylists.map { SPTPlaylist(playlistSearchResponse: $0) }
//                }
//                if let rawSongs = data.tracks?.items {
//                    self?.fetchedSongs = rawSongs.map { SPTSong(searchResponse: $0) }
//                }
//                if let strongSelf = self {
//                    strongSelf.viewControllers.removeAll()
//                    if !strongSelf.fetchedPlaylists.isEmpty {
//                        strongSelf.viewControllers.append(LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists))
//                    }
//                    if !strongSelf.fetchedAlbums.isEmpty {
//                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedAlbums, buttonBarTitle: "Albums"))
//                    }
//                    if !strongSelf.fetchedSingles.isEmpty {
//                        strongSelf.viewControllers.append(LibraryAlbumTableViewController(albums: strongSelf.fetchedSingles, buttonBarTitle: "Singles"))
//                    }
//                    if !strongSelf.fetchedSongs.isEmpty {
//                        strongSelf.viewControllers.append(LibrarySongTableViewController(songs: strongSelf.fetchedSongs))
//                    }
//                    if strongSelf.viewControllers.isEmpty {
//                        strongSelf.viewControllers.append(LibraryPlaylistTableViewController())
//                    }
//                }
//                completion()
//            }, error: { err in
//                error(err)
//        })
//    }
    
    override func followButtonTapped() {
        if !APMArtistEntity.doesArtistExist(artist: artist) {
            APMArtistEntity.createArtists(from: [artist])
        }
    }
}
