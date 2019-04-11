//
//  SPTSong.swift
//  smore
//
//  Created by Vignesh Babu on 3/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class SPTSong: Song {
    var originalImageLink: String?
    var name: String
    var genre: String
    var imageLink: URL?
    var id: String
    var playableString: String
    var artistName: String
    var streamingService: StreamingService = .spotify
    var trackNumber: Int
    var duration: TimeInterval
    
    init(response: SPTTrackResponse) {
        name = response.name!
        genre = ""
        imageLink = URL(string: response.album?.images?.first?.url ?? "")
        id = response.id!
        playableString = response.uri!
        artistName = response.artists?.first?.name ?? ""
        originalImageLink = response.album?.images?.first?.url ?? ""
        trackNumber = response.track_number ?? 0
        duration = TimeInterval(response.duration_ms ?? 0 / 1000)
    }
    
    init(topResponse: SPTArtistTopTracksResponse.SPTTrack) {
        name = topResponse.name!
        genre = ""
        imageLink = URL(string: topResponse.album?.images?.first?.url ?? "")
        id = topResponse.id!
        playableString = topResponse.uri!
        artistName = topResponse.artists?.first?.name ?? ""
        originalImageLink = topResponse.album?.images?.first?.url ?? ""
        trackNumber = topResponse.track_number ?? 0
        duration = TimeInterval(topResponse.duration_ms ?? 0 / 1000)
    }
    
    init(searchResponse: SPTSearchResponse.SPTTrack.SPTTrackItem) {
        name = searchResponse.name ?? ""
        genre = ""
        imageLink = URL(string: searchResponse.album?.images?.first?.url ?? "")
        id = searchResponse.id!
        playableString = searchResponse.uri!
        artistName = searchResponse.artists?.first?.name ?? ""
        originalImageLink = searchResponse.album?.images?.first?.url ?? ""
        trackNumber = searchResponse.track_number ?? 0
        duration = TimeInterval(searchResponse.duration_ms ?? 0 / 1000)
    }
    
//    Implement after playlists
//    init(trackData: APMPlaylistResponse.APMPlaylistData
//        .APMPlaylistRelationships.APMPlaylistTracks.APMPlaylistTrackData) {
//        name = trackData.attributes.name
//        genre = trackData.attributes.genreNames.first ?? ""
//        imageLink = trackData.attributes.artwork?.artworkImageURL(width: 300, height: 300)
//        id = trackData.id
//        playableString = trackData.attributes.playParams?.id ?? ""
//        artistName = trackData.attributes.artistName
//        originalImageLink = trackData.attributes.artwork?.url
//        trackNumber = trackData.attributes.trackNumber
//        duration = TimeInterval(trackData.attributes.durationInMillis / 1000)
//    }
    
    init(albumTrackData: SPTAlbumResponse.SPTTrack.SPTItem)
    {
        name = albumTrackData.name!
        genre = ""
        imageLink = nil
        id = albumTrackData.id!
        playableString = albumTrackData.uri ?? ""
        artistName = albumTrackData.artists?.first?.name ?? ""
        originalImageLink = ""
        trackNumber = albumTrackData.track_number ?? 0
        duration = TimeInterval(albumTrackData.duration_ms ?? 0 / 1000)
    }
    
}
