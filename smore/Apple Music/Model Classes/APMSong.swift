//
//  APMSong.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMSong: Song {
    var originalImageLink: String?
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
        originalImageLink = response.attributes.artwork.url
    }
    
    init(searchResponse: APMSearch.APMSearchResults.APMSearchSongs.APMSongData) {
        name = searchResponse.attributes.name
        genre = searchResponse.attributes.genreNames.first ?? ""
        imageLink = searchResponse.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        id = searchResponse.id
        playableString = searchResponse.attributes.playParams?.id ?? ""
        artistName = searchResponse.attributes.artistName
        originalImageLink = searchResponse.attributes.artwork?.url
    }
    
    init(trackData: APMPlaylistResponse.APMPlaylistData
        .APMPlaylistRelationships.APMPlaylistTracks.APMPlaylistTrackData) {
        name = trackData.attributes.name
        genre = trackData.attributes.genreNames.first ?? ""
        imageLink = trackData.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        id = trackData.id
        playableString = trackData.attributes.playParams?.id ?? ""
        artistName = trackData.attributes.artistName
        originalImageLink = trackData.attributes.artwork?.url
    }
    
}
