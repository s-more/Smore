//
//  SPTArtist.swift
//  smore
//
//  Created by Colin Williamson on 3/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SPTArtist: Artist {
    var genre: String
    var name: String
    var genres: [String]
    var imageLink: URL?
    var id: String
    var albums: [Album]
    var originalImageLink: String?
    var streamingService: StreamingService
    
    init(name: String, genre: String, imageLink: URL?, id: String) {
        self.name = name
        self.genres = [genre]
        self.genre = genre
        self.imageLink = imageLink
        self.id = id
        self.albums = []
        self.originalImageLink = ""
        self.streamingService = .spotify
    }
    
    init(response: SPTArtistResponse) {
        name = response.name ?? ""
        genres = response.genres ?? []
        genre = response.genres?.first ?? ""
        id = response.id ?? ""
        albums = []
        imageLink = URL(string: response.images?.first?.url ?? "")
        originalImageLink = response.images?.first?.url
        streamingService = .spotify
    }
    
    init(searchResponse: SPTSearchResponse.SPTArtist.SPTArtistItem) {
        name = searchResponse.name ?? ""
        genres = searchResponse.genres ?? []
        genre = searchResponse.genres?.first ?? ""
        id = searchResponse.id ?? ""
        albums = []
        imageLink = URL(string: searchResponse.images?.first?.url ?? "")
        originalImageLink = searchResponse.images?.first?.url
        streamingService = .spotify
    }
    
    
//    class func convert(results: APMSearch.APMSearchResults, imageSize: Int = 200) -> [APMArtist] {
//        return results.artists?.data.map { APMArtist(response: $0, imageSize: imageSize) } ?? []
//    }
    
    func albums(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        guard albums.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
    }
}

extension SPTArtist: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(genre)
    }
}

extension SPTArtist: Equatable {
    static func == (lhs: SPTArtist, rhs: SPTArtist) -> Bool {
        return lhs.id == rhs.id
    }
}
