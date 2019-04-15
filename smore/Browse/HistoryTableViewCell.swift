//
//  HistoryTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 4/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier = "historyTableViewCell"
    var didSelectAlbum: ((Album) -> Void)?
    var didSelectPlaylist: ((Playlist) -> Void)?
    
    var data: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.collectionViewLayout = FlowLayout(size: CGSize(width: 147, height: 202),
                                                         itemSpacing: 0, lineSpacing: 10, inset: 16.0)
    }
    
}

extension HistoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath)
        
        if let cell = cell as? PlaylistCollectionViewCell {
            if let album = data[indexPath.row] as? Album {
                cell.playlistImage.kf.setImage(with: album.imageLink,
                                               placeholder: UIImage(named: "artistPlaceholder"))
                cell.playlistName.text = album.name
                cell.subtitle.text = album.artistName
            } else if let playlist = data[indexPath.row] as? Playlist {
                cell.playlistImage.kf.setImage(with: playlist.imageLink,
                                               placeholder: UIImage(named: "artistPlaceholder"))
                cell.playlistName.text = playlist.name
                cell.subtitle.text = playlist.curatorName
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlist = data[indexPath.row] as? Playlist {
            didSelectPlaylist?(playlist)
        } else if let album = data[indexPath.row] as? Album {
            didSelectAlbum?(album)
        }
    }
    
    
}
