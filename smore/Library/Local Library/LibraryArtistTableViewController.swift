//
//  LibrarySongTableViewController.swift
//  smore
//
//  Created by Lil on 3/20/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

class LibraryArtistTableViewController: UITableViewController {
    
    init() {
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APMArtistEntity.fetchedResultsController.delegate = self
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APMArtistEntity.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableViewCell.preferredHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artistEntity = APMArtistEntity.fetchedResultsController.object(at: indexPath)
        let vm = ArtistLibraryViewModel(artist: APMArtist(artistEntity: artistEntity))
        let vc = LibraryViewController(viewModel: vm)
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LibraryArtistTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Artists")
    }
    
}

extension LibraryArtistTableViewController: ScrollHeightCalculable {
    func wrapperScrollViewSize(immobileSectionHeight: CGFloat) -> CGSize {
        let innerSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat((APMArtistEntity.fetchedResultsController.fetchedObjects?.count ?? 0) * Int(SearchTableViewCell.preferredHeight)))
        return CGSize(width: innerSize.width, height: innerSize.height + immobileSectionHeight)
    }
}

extension LibraryArtistTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        if type == .insert, let newIndexPath = newIndexPath {
            tableView.insertRows(at: [newIndexPath], with: .none)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        (parent as? LibraryViewController)?.applyContentSize()
    }
    

}
