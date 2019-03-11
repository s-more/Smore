//
//  APMArtist.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class APMArtist: Artist {
    var name: String
    var genre: String
    var imageLink: URL?
    var id: String
    var albums: [Album]
    var originalImageLink: String?
    
    init(name: String, genre: String, imageLink: URL?, originalImageLink: String?, id: String) {
        self.name = name
        self.genre = genre
        self.imageLink = imageLink
        self.id = id
        albums = []
        self.originalImageLink = originalImageLink
    }
    
    init(response: APMSearch.APMSearchResults.APMSearchArtists.APMSearchArtistsData, imageSize: Int) {
        name = response.attributes.name
        genre = response.attributes.genreNames.first ?? "Unknown Genre"
        id = response.id
        albums = response.relationships.albums.data.map { APMAlbum(relAlbumData: $0) }
        let artwork = response.relationships.albums.data.first?.attributes?.artwork
        imageLink = artwork?.artworkImageURL(width: imageSize, height: imageSize)
        originalImageLink = artwork?.url
    }
    
    class func convert(results: APMSearch.APMSearchResults, imageSize: Int = 200) -> [APMArtist] {
        return results.artists?.data.map { APMArtist(response: $0, imageSize: imageSize) } ?? []
    }
    
    func albums(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard albums.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
    }
}

extension APMArtist: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(genre)
    }
}

extension APMArtist: Equatable {
    static func == (lhs: APMArtist, rhs: APMArtist) -> Bool {
        return lhs.id == rhs.id
    }
}
