//
//  UIAlertAction+MoreActions.swift
//  smore
//
//  Created by Jing Wei Li on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func showMoreAction(from song: Song, on vc: UIViewController) {
        let songExists = SongEntity.doesSongExist(song: song)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if !songExists {
            actionSheet.addAction(UIAlertAction(
                title: "Add to Library",
                style: .default,
                handler:
                { _ in
                    SongEntity.makeSong(from: song)
                    vc.view.addSubview(LottieActivityIndicator.checkmark)
                }))
        }
        actionSheet.addAction(UIAlertAction(
            title: "Add to Playlist",
            style: .default,
            handler: { _ in
                // implement
            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.view.tintColor = .themeColor
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}
