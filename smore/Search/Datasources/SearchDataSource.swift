//
//  SearchDataSource.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

/// - Brilliant example of protocol inheritence.
protocol SearchDataSource: UITableViewDataSource {
    var name: String { get set }
    var songs: [Song] { get set }
    var albums: [Album] { get set }
    var artists: [Artist] { get set }
    var playlists: [Playlist] { get set }
}
