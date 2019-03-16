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
    var steamingService: StreamingService = .appleMusic
    var trackNumber: Int
    var duration: TimeInterval
    
    init(response: APMTopChartResponse.APMTopChartResonseResults.APMSong.APMSongData) {
        name = response.attributes.name
        genre = response.attributes.genreNames.first ?? ""
        imageLink = response.attributes.artwork.artworkImageURL(width: 300, height: 300)
        id = response.id
        playableString = response.attributes.playParams.id
        artistName = response.attributes.artistName
        originalImageLink = response.attributes.artwork.url
        trackNumber = response.attributes.trackNumber
        duration = TimeInterval(response.attributes.durationInMillis / 1000)
    }
    
    init(searchResponse: APMSearch.APMSearchResults.APMSearchSongs.APMSongData) {
        name = searchResponse.attributes.name
        genre = searchResponse.attributes.genreNames.first ?? ""
        imageLink = searchResponse.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        id = searchResponse.id
        playableString = searchResponse.attributes.playParams?.id ?? ""
        artistName = searchResponse.attributes.artistName
        originalImageLink = searchResponse.attributes.artwork?.url
        trackNumber = searchResponse.attributes.trackNumber
        duration = TimeInterval(searchResponse.attributes.durationInMillis / 1000)
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
        trackNumber = trackData.attributes.trackNumber
        duration = TimeInterval(trackData.attributes.durationInMillis / 1000)
    }
    
    init(albumTrackData: APMAlbumResponse.APMAlbumData.APMAlbumRelationships.APMAlbumTrack.APMAlbumTrackData)
    {
        name = albumTrackData.attributes.name
        genre = albumTrackData.attributes.genreNames.first ?? ""
        imageLink = albumTrackData.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        id = albumTrackData.id
        playableString = albumTrackData.attributes.playParams?.id ?? ""
        artistName = albumTrackData.attributes.artistName
        originalImageLink = albumTrackData.attributes.artwork?.url
        trackNumber = albumTrackData.attributes.trackNumber
        duration = TimeInterval(albumTrackData.attributes.durationInMillis / 1000)
    }
    
}
