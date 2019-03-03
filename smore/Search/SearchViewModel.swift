//
//  SearchViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: NSObject {
    
    var searchHintsDataSource = SearchHintDataSource()
    let searchDataSources: [SearchDataSource]
    let sectionHeaders: [String] = ["Artists", "Albums", "Playlists", "Songs"]
    var initialSearchBarPosition: CGFloat = 0
    
    var shouldNavBarBeShown = false
    
    init(dataSources: [SearchDataSource]) {
        searchDataSources = dataSources
        super.init()
    }
    
    static func scrollViewContentSize(from dataSource: SearchDataSource) -> CGSize {
        let size = tableViewContentSize(from: dataSource)
        return CGSize(width: size.width, height: size.height + 220)
    }
    
    static func tableViewContentSize(from dataSource: SearchDataSource) -> CGSize {
        let headerHeights = 60 * 4
        let artistsHeight = 210
        let otherheights =
            (dataSource.albums.count + dataSource.playlists.count + dataSource.songs.count)
                * Int(SearchTableViewCell.preferredHeight)
        return CGSize(width: Int(UIScreen.main.bounds.width),
                      height: headerHeights + artistsHeight + otherheights + 20)
    }
    
    static func populateSearchDataSource(
        with dataSource: SearchDataSource,
        data: APMSearch.APMSearchResults) -> SearchDataSource
    {
        if let albums = data.albums?.data {
            dataSource.albums = albums.map { APMAlbum(response: $0) }
        } else {
            dataSource.albums = []
        }
        if let songs = data.songs?.data {
            dataSource.songs = songs.map { APMSong(searchResponse: $0) }
        } else {
            dataSource.songs = []
        }
        if let artists = data.artists?.data {
            dataSource.artists = artists.map { APMArtist(response: $0, imageSize: 200) }
        } else {
            dataSource.artists = []
        }
        if let playlists = data.playlists?.data {
            dataSource.playlists = playlists.map { APMPlaylist(searchResponse: $0) }
        } else {
            dataSource.playlists = []
        }
        return dataSource
    }
}
