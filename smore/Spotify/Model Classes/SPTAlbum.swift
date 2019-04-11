//
//  SPTAlbum.swift
//  smore
//
//  Created by Vignesh Babu on 3/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class SPTAlbum: Album {
    var id: String
    var name: String
    var artistName: String
    var playableString: String
    var imageLink: URL?
    var releaseDate: String
    var description: String?
    var originalImageLink: String?
    var songs: [Song]
    var streamingService: StreamingService = .spotify
    var isSingle: Bool
    
    init(response: SPTAlbumResponse) {
        id = response.id!
        name = response.name!
        artistName = response.artists?.first?.name ?? ""
        playableString = response.uri ?? ""
        imageLink = URL(string: response.images?.first?.url ?? "")
        releaseDate = response.release_date ?? ""
        description = ""
        originalImageLink = response.images?.first?.url ?? ""
        isSingle = response.album_type == "single"
        songs = []
    }
    
    init(relAlbumData: SPTArtistAlbumsResponse.SPTItem) {
        
        id = relAlbumData.id!
        name = relAlbumData.name ?? ""
        artistName = relAlbumData.artists.first?.name ?? ""
        playableString = relAlbumData.uri ?? ""
        imageLink = URL(string: relAlbumData.images?.first?.url ?? "")
        releaseDate = relAlbumData.release_date ?? ""
        description = ""
        originalImageLink = relAlbumData.images?.first?.url
        isSingle = relAlbumData.album_type == "Single"
        songs = []
    }
    
    init(searchAlbumData: SPTSearchResponse.SPTAlbum.SPTAlbumItem) {
        
        id = searchAlbumData.id ?? ""
        name = searchAlbumData.name ?? ""
        artistName = searchAlbumData.artists.first?.name ?? ""
        playableString = searchAlbumData.uri ?? ""
        imageLink = URL(string: searchAlbumData.images?.first?.url ?? "")
        releaseDate = searchAlbumData.release_date ?? ""
        description = ""
        originalImageLink = searchAlbumData.images?.first?.url
        isSingle = searchAlbumData.album_type == "Single"
        songs = []
    }
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard songs.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        SpotifyAPI.getAlbum(token: id, albumID: id, success: { [weak self] data in
            DispatchQueue.global(qos: .userInitiated).async {
//                self?.songs = data.tracks?.items.map { SPTSong(albumTrackData: $0) }
                DispatchQueue.main.async { completion() }
            }
            }, error: { err in
                DispatchQueue.main.async { error(err) }
        })
    }
    
    
}
