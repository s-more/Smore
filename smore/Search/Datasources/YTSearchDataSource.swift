//
//  YTSearchDataSource.swift
//  smore
//
//  Created by sin on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

import UIKit
import Kingfisher
import RxSwift

class YTSearchDataSource: NSObject, SearchDataSource {
    var searchHints: [String] = []
    var name: String = "YouTube"
    var songs: [Song] = []
    var albums: [Album] = []
    var artists: [Artist] = []
    var playlists: [Playlist] = []
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                cell.serviceIcon.image = UIImage(named: "youtubeIcon")
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
                cell.serviceIcon.image = UIImage(named: "youtubeIcon")
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
                cell.serviceIcon.image = UIImage(named: "youtubeIcon")
            }
            return cell
        default: break
            
        }
        
        return UITableViewCell()
    }
    
    func searchHints(from term: String) -> Observable<([String]?, Error?)> {
        return Observable.empty()
    }
    
    func searchHintDataSource(from hints: [String]) -> SearchHintDataSource {
        return SearchHintDataSource(searchHints: hints)
    }
    
    func searchCatalog(
        with text: String,
        completion: @escaping ([Artist], [Album], [Playlist], [Song]) -> Void,
        error: @escaping (Error) -> Void)
    {
    
        YouTubeAPI.search( with: text, success: { data in
            DispatchQueue.global(qos: .userInitiated).async {
                var songs: [Song] = []
                
                let tempRawSongs = data.items.filter { ($0).id.kind == "youtube#video" }
                songs = tempRawSongs.map { YTVideo( resource: $0 ) }
                
                completion([], [], [], songs)
            }
            }, error: { e in error(e)
        })
        
    }
    
    
}

