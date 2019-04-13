//
//  AddToPlaylistViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Photos

class AddToPlaylistViewModel: NSObject {
    let existingPlaylists: [Playlist]
    let songToAdd: Song

    var imageURL: URL?
    
    init(songToAdd: Song) {
        self.songToAdd = songToAdd
        existingPlaylists = PlaylistEntity.playlists()
        super.init()
    }
    
    func requestPhotoAuthAndPresentImagePicker(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { authStatus in
                if authStatus == .authorized {
                   completion()
                }
            }
        } else {
            completion()
        }
    }
}

extension UIImageView {
    
    func setImageWithAssetURL(_ assetURL: URL, size: CGSize) {
        
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
        
        guard let result = asset.firstObject else { return }
        
        let imageManager = PHImageManager.default()
        
        imageManager.requestImage(
            for: result,
            targetSize: size,
            contentMode: PHImageContentMode.aspectFill,
            options: nil)
        { [weak self ] image, dict in
            if let image = image {
                self?.image = image
            }
        }
    }
}
