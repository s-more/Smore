//
//  LibraryContentViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlaylistContentViewModel: NSObject {
    let playlist: Playlist
    let highResImageURL: URL?
    
    init(playlist: Playlist) {
        self.playlist = playlist
        highResImageURL = Utilities.highResImage(from: playlist.originalImageLink)
        super.init()
    }
    
    func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        playlist.songs(completion: {
            DispatchQueue.main.async { completion() }
        }, error: { err in
            DispatchQueue.main.async { error(err) }
        })
    }
}
