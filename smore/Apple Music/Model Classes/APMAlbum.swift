//
//  APMAlbum.swift
//  smore
//
//  Created by Jing Wei Li on 2/28/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMAlbum: Album {
    var id: String
    var name: String
    var artistName: String
    var playableString: String
    var imageLink: URL?
    var releaseDate: String
    var description: String?
    var songs: [Song]
    
    init(response: APMSearch.APMSearchResults.APMSearchAlbums.APMAlbumData) {
        id = response.id
        name = response.attributes.name
        artistName = response.attributes.artistName
        playableString = response.attributes.playParams?.id ?? ""
        imageLink = response.attributes.artwork?.artworkImageURL(width: 300, height: 300)
        releaseDate = response.attributes.releaseDate
        description = response.attributes.editorialNotes?.standard
        songs = []
    }
    
    init(relAlbumData: APMSearch.APMSearchResults.APMSearchArtists
        .APMSearchArtistsData.APMSearchArtistRelationships
        .APMSearchArtistRelAlbums.APMSearchArtistRelAlbumData) {
        
        id = relAlbumData.id
        name = relAlbumData.attributes?.name ?? ""
        artistName = relAlbumData.attributes?.artistName ?? ""
        playableString = relAlbumData.attributes?.playParams?.id ?? ""
        imageLink = relAlbumData.attributes?.artwork?.artworkImageURL(width: 300, height: 300)
        releaseDate = relAlbumData.attributes?.releaseDate ?? ""
        description = relAlbumData.attributes?.editorialNotes?.standard
        songs = []
    }
    
    func songs(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard songs.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
    }
    
    
}
