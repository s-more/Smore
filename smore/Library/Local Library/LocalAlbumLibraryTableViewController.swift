//
//  LocalAlbumLibraryTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 4/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

class LocalAlbumTableViewController: LocalLibrayTableViewController {
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        return AlbumEntity.fetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
    }
    
    override var burButtonTitle: String { return "Albums" }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                 for: indexPath)
        
        let albumEntity = AlbumEntity.fetchedResultsController.object(at: indexPath)
        if let cell = cell as? SearchTableViewCell,
            let album = AlbumEntity.standardAlbum(from: albumEntity) {
            cell.masterImage.kf.setImage(with: album.imageLink,
                                         placeholder: UIImage(named: "artistPlaceholder"))
            cell.masterLabel.text = album.name
            cell.subtitleLabel.text = album.artistName
            cell.serviceIcon.image = album.streamingService.icon
            cell.masterImage.addRoundCorners(cornerRadius: 10)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let albumEntity = AlbumEntity.fetchedResultsController.object(at: indexPath)
        if let album = AlbumEntity.standardAlbum(from: albumEntity) {
            let vc = AlbumContentViewController(album: album)
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
