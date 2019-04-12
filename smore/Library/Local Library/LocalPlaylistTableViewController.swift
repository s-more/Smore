//
//  LocalPlaylistTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 4/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

class LocalPlaylistTableViewController: LocalLibrayTableViewController {
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        return PlaylistEntity.fetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
    }
    
    override var barButtonTitle: String{
        return "Playlists"
    }
    
    // MARK: - Table View Data Source and Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                 for: indexPath)
        
        let playlistEntity = PlaylistEntity.fetchedResultsController.object(at: indexPath)
        
        if let cell = cell as? SearchTableViewCell,
            let playlist = PlaylistEntity.standardPlaylist(from: playlistEntity) {
            if let url = playlistEntity.imageLink, url.absoluteString.starts(with: "assets-library") {
                let width = UIScreen.main.bounds.width * 0.2 * UIScreen.main.scale
                cell.masterImage.setImageWithAssetURL(url, size: CGSize(width: width, height: width))
            } else {
                cell.masterImage.kf.setImage(with: playlist.imageLink,
                                             placeholder: UIImage(named: "artistPlaceholder"))
            }
            cell.masterLabel.text = playlist.name
            cell.subtitleLabel.text = playlist.curatorName
            cell.serviceIcon.image = playlist.streamingService.icon
            cell.masterImage.addRoundCorners(cornerRadius: 10)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlistEntity = PlaylistEntity.fetchedResultsController.object(at: indexPath)
        if let playlist = PlaylistEntity.standardPlaylist(from: playlistEntity) {
            let vm = PlaylistContentViewModel(playlist: playlist)
            let vc = PlaylistContentViewController(viewModel: vm)
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


