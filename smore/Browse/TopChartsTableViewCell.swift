//
//  TopChartsTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class TopChartsTableViewCell: UITableViewCell {
    static let identifier = "topChartsCollectionView"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var songs: [APMSong] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.collectionViewLayout = FlowLayout(size: CGSize(width: 147, height: 202),
                                                         itemSpacing: 0, lineSpacing: 10, inset: 16.0)
    }
}

extension TopChartsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath)
        
        if let cell = cell as? PlaylistCollectionViewCell {
            cell.playlistImage.kf.setImage(with: songs[indexPath.row].imageLink,
                                           placeholder: UIImage(named: "artistPlaceholder"))
            cell.playlistName.text = songs[indexPath.row].name
            cell.subtitle.text = songs[indexPath.row].artistName
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if songs[indexPath.row].streamingService == StreamingService.spotify {
            Player.shared.stop()
            SpotifyRemote.shared.appRemote.playerAPI?.play(songs[indexPath.row].playableString, callback: SpotifyRemote.shared.defaultCallback)
        }else {
            SpotifyRemote.shared.appRemote.playerAPI?.pause(SpotifyRemote.shared.defaultCallback)
            MiniPlayer.shared.configure(with: songs[indexPath.row])
            MusicQueue.shared.queue.value = Array(songs[indexPath.row ..< songs.count])
        }
    }
}
