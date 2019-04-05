//
//  LocalArtistTableViewController.swift
//  smore
//
//  Created by Lil on 3/20/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

class LocalArtistTableViewController: LocalLibrayTableViewController {
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        return APMArtistEntity.fetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
    }
    
    override var burButtonTitle: String { return "Artists" }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                 for: indexPath)
        
        let artistEntity = APMArtistEntity.fetchedResultsController.object(at: indexPath)
        let artist = APMArtist(artistEntity: artistEntity)
        if let cell = cell as? SearchTableViewCell {
            cell.masterImage.kf.setImage(with: artist.imageLink,
                                         placeholder: UIImage(named: "artistPlaceholder"))
            cell.masterLabel.text = artist.name
            cell.subtitleLabel.text = artist.genre
            cell.serviceIcon.image = artist.streamingService.icon
            cell.masterImage.addRoundCorners(cornerRadius: 37)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artistEntity = APMArtistEntity.fetchedResultsController.object(at: indexPath)
        let vm = ArtistLibraryViewModel(artist: APMArtist(artistEntity: artistEntity))
        let vc = LibraryViewController(viewModel: vm)
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
