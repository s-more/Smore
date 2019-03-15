//
//  Playlist.swift
//  smore
//
//  Created by Jing Wei Li on 2/27/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol Playlist {
    var id: String { get set }
    var name: String { get set }
    var curatorName: String { get set }
    var playableString: String { get set }
    var originalImageLink: String? { get set }
    var imageLink: URL? { get set }
    var songs: [Song] { get set }
    var streamingService: StreamingService { get set }
    var description: String? { get set }
    
    /// Fetch all songs from this playlist.
    /// - Once done with the web request just assign the returned songs to `songs`.
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void)
}
