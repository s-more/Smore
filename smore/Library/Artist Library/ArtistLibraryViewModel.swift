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
    var highResImageURL: URL?
    var isBarShown = false
    var initialButtonBarPosition: CGFloat = 0
    var isButtonBarPositionSet = false
    
    var viewControllers: [UITableViewController & ScrollHeightCalculable & IndicatorInfoProvider] = [
        LibraryPlaylistTableViewController()
    ]
    
    /// init from an Artist.
    init(artist: Artist) {
        self.artist = artist
        highResImageURL = ArtistLibraryViewModel.highResImage(from: artist.originalImageLink)
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
                if let strongSelf = self {
                    strongSelf.viewControllers = [
                        LibraryPlaylistTableViewController(playlists: strongSelf.fetchedPlaylists),
                        LibraryAlbumTableViewController(albums: strongSelf.fetchedAlbums)
                    ]
                }
                completion()
            }, error: { err in
                error(err)
            })
    }
    
    func isVCEmpty(vc: UIViewController) -> Bool {
        if let vc = vc as? LibraryPlaylistTableViewController {
            return vc.playlists.isEmpty
        }
        return true
    }
    
    // MARK: - Private
    private static func highResImage(from url: String?) -> URL? {
        if let url = url {
            let availableWidth = Int(UIScreen.main.bounds.width * UIScreen.main.scale * 0.75)
            let replaceOne = url.replacingOccurrences(of: "{w}", with: "\(availableWidth)")
            let replaceTwo = replaceOne.replacingOccurrences(of: "{h}", with: "\(availableWidth)")
            if let resultURL = URL(string: replaceTwo) {
                return resultURL
            }
        }
        return nil
    }
    
}
