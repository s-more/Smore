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
    var nameLabelPositon: CGFloat? = nil
    var isNavBarShown = false
    
    init(playlist: Playlist) {
        self.playlist = playlist
        highResImageURL = PlaylistContentViewModel.highResImage(from: playlist.originalImageLink)
        super.init()
    }
    
    func prepareData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        playlist.songs(completion: {
            DispatchQueue.main.async { completion() }
        }, error: { err in
            DispatchQueue.main.async { error(err) }
        })
    }
    
    var tableViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: CGFloat(playlist.songs.count * Int(StartupSearchTableViewCell.preferredHeight)))
    }
    
    var scrollViewContentSize: CGSize {
        let tableViewSize = tableViewContentSize
        let screenWidth = UIScreen.main.bounds.width
        return CGSize (width: tableViewSize.width, height: tableViewSize.height + screenWidth)
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
