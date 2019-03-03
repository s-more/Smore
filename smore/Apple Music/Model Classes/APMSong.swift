//
//  APMSong.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMSong: Song {
    var name: String
    var genre: String
    var imageLink: URL?
    var id: String
    var playableString: String
    var artistName: String
    
    init(response: APMTopChartResponse.APMTopChartResonseResults.APMSong.APMSongData) {
        name = response.attributes.name
        genre = response.attributes.genreNames.first ?? ""
        imageLink = response.attributes.artwork.artworkImageURL(width: 300, height: 300)
        id = response.id
        playableString = response.attributes.playParams.id
        artistName = response.attributes.artistName
    }
    
    init(searchResponse: APMSearch.APMSearchResults.APMSearchSongs.APMSongData) {
        name = searchResponse.attributes.name
        genre = searchResponse.attributes.genreNames.first ?? ""
        imageLink = searchResponse.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        id = searchResponse.id
        playableString = searchResponse.attributes.playParams?.id ?? ""
        artistName = searchResponse.attributes.artistName
    }
    
}
