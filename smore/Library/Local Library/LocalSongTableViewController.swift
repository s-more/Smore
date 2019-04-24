//
//  LocalSongTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 4/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

class LocalSongTableViewController: LocalLibrayTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: SongTableViewCell.identifier)
        
    }
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        return SongEntity.fetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
    }
    
    override var barButtonTitle: String { return "Songs" }
    
    override var rowHeight: CGFloat { return SongTableViewCell.preferredHeight }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier,
                                                 for: indexPath)
        
        let songEntity = SongEntity.fetchedResultsController.object(at: indexPath)
        let song = SongEntity.standardSong(from: songEntity)
        if let cell = cell as? SongTableViewCell, let song = song {
            cell.configure(with: song)
            cell.songImageView.addRoundCorners(cornerRadius: 10)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let song = SongEntity.standardSong(
            from: SongEntity.fetchedResultsController.object(at: indexPath))
        if let song = song, let objects = SongEntity.fetchedResultsController.fetchedObjects {
            if song.streamingService.isServiceEnabled {
                if song.streamingService == StreamingService.spotify {
                    Player.shared.stop()
                    SpotifyRemote.shared.appRemote.playerAPI?.play(song.playableString, callback: SpotifyRemote.shared.defaultCallback)
                }else {
                    SpotifyRemote.shared.appRemote.playerAPI?.pause(SpotifyRemote.shared.defaultCallback)
                    MiniPlayer.shared.configure(with: song)
                    MusicQueue.shared.queue.value = Array(objects[indexPath.row ..< objects.count])
                        .compactMap { SongEntity.standardSong(from: $0) }
                }
            } else {
                SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "This service is not enabled, please enable it in the setting tab.")
            }
        }
        // Array(album.songs
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongTableViewCell.preferredHeight
    }
}
