//
//  LocalLibraryViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/29/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class LocalLibraryViewModel: LibraryViewModel {
    
    override init() {
        super.init()
    }
    
    override var highResImage: UIImage? {
        return UIImage(named: "LibraryBackgroundImage")
    }
    
    override var hideFollowButton: Bool {
        return true
    }
    
    override var disableFollowButton: Bool {
        return true
    }
    
    override var titleText: String {
        return "Library"
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fetchedArtists = APMArtistEntity.favArtists()
            strongSelf.viewControllers.removeAll()
            SmoreDatabase.context.perform {
                do {
                    try APMArtistEntity.fetchedResultsController.performFetch()
                    try AlbumEntity.fetchedResultsController.performFetch()
                    try SongEntity.fetchedResultsController.performFetch()
                } catch let error {
                    SwiftMessagesWrapper.showErrorMessage(title: "Error", body: error.localizedDescription)
                }
            }
            strongSelf.viewControllers.append(LocalArtistTableViewController())
            strongSelf.viewControllers.append(LocalAlbumTableViewController())
            strongSelf.viewControllers.append(LocalSongTableViewController())
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
