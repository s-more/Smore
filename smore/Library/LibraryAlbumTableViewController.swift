//
//  LibraryAlbumTableViewController.swift
//  smore
//
//  Created by Colin Williamson on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip

class LibraryAlbumTableViewController: UITableViewController {
    let albums: [Album]
    
    init(albums: [Album]) {
        self.albums = albums
        super.init(nibName: "LibraryAlbumTableViewController", bundle: Bundle.main)
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
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)

        if let cell = cell as? SearchTableViewCell {
            cell.masterImage.kf.setImage(with: albums[indexPath.row].imageLink, placeholder: UIImage(named: "artistPlaceholder"))
            cell.masterLabel.text = albums[indexPath.row].name
            cell.subtitleLabel.text = albums[indexPath.row].releaseDate
            cell.serviceIcon.image = albums[indexPath.row].streamingService.icon
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableViewCell.preferredHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AlbumContentViewController(album: albums[indexPath.row])
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LibraryAlbumTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Albums")
    }
}


extension LibraryAlbumTableViewController: ScrollHeightCalculable {
    func wrapperScrollViewSize(immobileSectionHeight: CGFloat) -> CGSize {
        let innerSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(albums.count * Int(SearchTableViewCell.preferredHeight)))
        return CGSize(width: innerSize.width, height: innerSize.height + immobileSectionHeight)
    }
}
