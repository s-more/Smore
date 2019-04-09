//
//  LocalLibrayTableViewController.swift
//  smore
//
//  Created by Lil on 4/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import CoreData

/// - Override at least 4 methods/ vars to get it to work:
///   - fetchedResultsController
///   - burButtonTitle
///   - tableview cellForRowAt IndexPath
/// - tableview didSelectRowAt IndexPath
class LocalLibrayTableViewController: UITableViewController {
    
    // MARK: - Overridables
    open var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        return nil
    }
    
    open var barButtonTitle: String { return "" }
    
    open var rowHeight: CGFloat {
        return SearchTableViewCell.preferredHeight
    }
    
    // MARK: - Init and lifecycles
    
    init() {
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController?.delegate = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // implement
    }
    
}

extension LocalLibrayTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: barButtonTitle)
    }
    
}

extension LocalLibrayTableViewController: ScrollHeightCalculable {
    func wrapperScrollViewSize(immobileSectionHeight: CGFloat) -> CGSize {
        let innerSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat((fetchedResultsController?.fetchedObjects?.count ?? 0) * Int(rowHeight)))
        return CGSize(width: innerSize.width, height: innerSize.height + immobileSectionHeight)
    }
}

extension LocalLibrayTableViewController: NSFetchedResultsControllerDelegate {
    
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

