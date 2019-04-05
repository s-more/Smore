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
    
    override var burButtonTitle: String { return "Songs" }
    
    override var rowHeight: CGFloat { return SongTableViewCell.preferredHeight }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier,
                                                 for: indexPath)
        
        let songEntity = SongEntity.fetchedResultsController.object(at: indexPath)
        let song = SongEntity.standardSong(from: songEntity)
        if let cell = cell as? SongTableViewCell {
            cell.songImageView.kf.setImage(with: song?.imageLink,
                                           placeholder: UIImage(named: "artistPlaceholder"))
            cell.songTitle.text = song?.name
            cell.songSubtitle.text = song?.artistName
            cell.songImageView.addRoundCorners(cornerRadius: 10)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let song = SongEntity.standardSong(
            from: SongEntity.fetchedResultsController.object(at: indexPath))
        if let song = song, let objects = SongEntity.fetchedResultsController.fetchedObjects {
            MiniPlayer.shared.configure(with: song)
            MusicQueue.shared.queue.value = Array(objects[indexPath.row ..< objects.count])
                                            .compactMap { SongEntity.standardSong(from: $0) }
        }
        // Array(album.songs
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongTableViewCell.preferredHeight
    }
}
