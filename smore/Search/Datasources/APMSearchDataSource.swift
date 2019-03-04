//
//  APMSearchDataSource.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class APMSearchDataSource: NSObject, SearchDataSource {
    var isSearchHinting: Bool = true
    var name: String = "Apple Music"
    var songs: [Song] = []
    var albums: [Album] = []
    var artists: [Artist] = []
    var playlists: [Playlist] = []
    var searchHints: [String] = []
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchHinting ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isSearchHinting else { return searchHints.count }
        switch section {
        case 0:
            return 1 // since the horizontally scrolling collection view is only 1 cell
        case 1:
            return albums.count
        case 2:
            return playlists.count
        case 3:
            return songs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !isSearchHinting else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? GenericTableViewCell {
                cell.textLabel?.text = searchHints[indexPath.row]
            }
            return cell
        }
        
        //not search hinting
        switch indexPath.section {
        case 0: // artists
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? SuggestedTableViewCell {
                cell.artists = artists
            }
            return cell
        case 1: // albums
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                    for: indexPath)
            if let cell = cell as? SearchTableViewCell {
                cell.masterImage.kf.setImage(with: albums[indexPath.row].imageLink,
                                             placeholder: UIImage(named: "artistPlaceholder"))
                cell.masterLabel.text = albums[indexPath.row].name
                cell.subtitleLabel.text = albums[indexPath.row].artistName
                cell.serviceIcon.image = UIImage(named: "appleLogo")
            }
            return cell
        case 2: // playlists
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? SearchTableViewCell {
                cell.masterImage.kf.setImage(with: playlists[indexPath.row].imageLink,
                                             placeholder: UIImage(named: "artistPlaceholder"))
                cell.masterLabel.text = playlists[indexPath.row].name
                cell.subtitleLabel.text = playlists[indexPath.row].curatorName
                cell.serviceIcon.image = UIImage(named: "appleLogo")
            }
            return cell
        case 3: // songs
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? SearchTableViewCell {
                cell.masterImage.kf.setImage(with: songs[indexPath.row].imageLink,
                                             placeholder: UIImage(named: "artistPlaceholder"))
                cell.masterLabel.text = songs[indexPath.row].name
                cell.subtitleLabel.text = songs[indexPath.row].artistName
                cell.serviceIcon.image = UIImage(named: "appleLogo")
            }
            return cell
        default: break
            
        }
        
        return UITableViewCell()
    }
    
    func searchHints(from term: String) -> Observable<([String]?, Error?)> {
        return AppleMusicAPI.rx.searchHints(from: term)
    }
}
