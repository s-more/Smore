//
//  LibraryViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/29/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class LibraryViewModel: NSObject {
    
    final var fetchedAlbums: [Album] = []
    final var fetchedSingles: [Album] = []
    final var fetchedPlaylists: [Playlist] = []
    final var fetchedSongs: [Song] = []
    final var fetchedArtists: [Artist] = []
    final var isBarShown = false
    final var initialButtonBarPosition: CGFloat = 0
    final var isButtonBarPositionSet = false
    
    final var viewControllers: [UITableViewController & ScrollHeightCalculable & IndicatorInfoProvider] = [
        LibraryPlaylistTableViewController()
    ]
    
    override init() {
        super.init()
    }
    
    // MARK: - Overridables
    open var hideFollowButton: Bool { return false }
    
    open var disableFollowButton: Bool { return false }
    
    open var titleText: String { return "" }
    
    open var highResImage: UIImage? { return nil }
    
    open var highResImageURL: URL? { return nil }
    
    open var details: String { return "" }
    
    open func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {}
    
    open func followButtonTapped() {}
    
}
