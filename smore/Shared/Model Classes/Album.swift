//
//  Album.swift
//  smore
//
//  Created by Jing Wei Li on 2/27/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol Album {
    var id: String { get set }
    var name: String { get set }
    var artistName: String { get set }
    var playableString: String { get set }
    var originalImageLink: String? { get set }
    var imageLink: URL? { get set }
    var releaseDate: String { get set }
    var description: String? { get set }
    var songs: [Song] { get set }
    
    /// Fetch all songs from this album.
    /// - Once done with the web request just assign the returned songs to `songs`.
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void)
}
