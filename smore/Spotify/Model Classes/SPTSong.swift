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
    
    init(trackData: SPTPlaylistResponse.SPTTrack.SPTPlaylistTrack) {
        name = trackData.track?.name ?? ""
        genre = ""
        imageLink = URL(string: trackData.track?.album?.images?.first?.url ?? "")
        id = trackData.track?.id ?? ""
        playableString = trackData.track?.uri ?? ""
        artistName = trackData.track?.artists?.first?.name ?? ""
        originalImageLink = trackData.track?.album?.images?.first?.url ?? ""
        trackNumber = trackData.track?.track_number ?? 0
        duration = TimeInterval(trackData.track?.duration_ms ?? 0 / 1000)
    }
    
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
