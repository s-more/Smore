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
    
    func search(
        with text: String,
        dataSource: SearchDataSource,
        completion: @escaping (SearchDataSource) -> Void,
        error: @escaping (Error) -> Void)
    {
        dataSource.searchCatalog(with: text, completion: { artists, albums, playlists, songs in
            dataSource.albums = albums
            dataSource.artists = artists
            dataSource.playlists = playlists
            dataSource.songs = songs
            DispatchQueue.main.async { completion(dataSource) }
        }, error: { err in
            DispatchQueue.main.async { error(err) }
        })
    }
}
