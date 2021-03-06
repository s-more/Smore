//
//  SPTSearchDataSource.swift
//  smore
//
//  Created by Colin Williamson on 4/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class SPTSearchDataSource: NSObject, SearchDataSource {
    var name: String = "Spotify"
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
                cell.serviceIcon.image = StreamingService.spotify.icon
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
                cell.serviceIcon.image = StreamingService.spotify.icon
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
                cell.serviceIcon.image = StreamingService.spotify.icon
            }
            return cell
        default: break
            
        }
        
        return UITableViewCell()
    }
    
    func searchHints(from term: String) -> Observable<([String]?, Error?)> {
        return AppleMusicAPI.rx.searchHints(from: term)
    }
    
    func searchHintDataSource(from hints: [String]) -> SearchHintDataSource {
        return SearchHintDataSource(searchHints: hints)
    }
    
    func searchCatalog(
        with text: String,
        completion: @escaping ([Artist], [Album], [Playlist], [Song]) -> Void,
        error: @escaping (Error) -> Void)
    {
        let SPTToken = SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? ""
        SpotifyAPI.searchCatalog(token: SPTToken, term: text, success: { data in
            DispatchQueue.global(qos: .userInitiated).async {
                var artists: [Artist] = []
                var albums: [Album] = []
                var playlists: [Playlist] = []
                var songs: [Song] = []
                
                if let rawAlbums = data.albums?.items {
                    albums = rawAlbums.map { SPTAlbum(searchAlbumData: $0) }
                }
                if let rawArtists = data.artists?.items {
                    artists = rawArtists.map { SPTArtist(searchResponse: $0)}
                }
                if let rawPlaylists = data.playlists?.items {
                    playlists = rawPlaylists.map { SPTPlaylist(playlistSearchResponse: $0) }
                }
                if let rawSongs = data.tracks?.items {
                    songs = rawSongs.map { SPTSong(searchResponse: $0) }
                }
                completion(artists, albums, playlists, songs)
            }
        }, error: { e in
            error(e)
        })
    }
}
