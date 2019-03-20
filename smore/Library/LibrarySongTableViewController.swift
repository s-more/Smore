//
//  LibrarySongTableViewController.swift
//  smore
//
//  Created by sin on 3/20/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip

class LibrarySongTableViewController: UITableViewController {
    let songs: [Song]
    
    init(songs: [Song]) {
        self.songs = songs
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    init() {
        songs = []
        super.init(nibName: "LibraryPlaylistTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                 for: indexPath)
        
        if let cell = cell as? SearchTableViewCell {
            cell.masterImage.kf.setImage(with: songs[indexPath.row].imageLink,
                                         placeholder: UIImage(named: "artistPlaceholder"))
            cell.masterLabel.text = songs[indexPath.row].name
            cell.subtitleLabel.text = songs[indexPath.row].genre
            cell.serviceIcon.image = songs[indexPath.row].streamingService.icon
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableViewCell.preferredHeight
    }
    
}

extension LibrarySongTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Songs")
    }
    
}

extension LibrarySongTableViewController: ScrollHeightCalculable {
    func wrapperScrollViewSize(immobileSectionHeight: CGFloat) -> CGSize {
        let innerSize = CGSize(width: UIScreen.main.bounds.width,
                               height: CGFloat(songs.count * Int(SearchTableViewCell.preferredHeight)))
        return CGSize(width: innerSize.width, height: innerSize.height + immobileSectionHeight)
    }
}
