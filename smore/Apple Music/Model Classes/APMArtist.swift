//
//  APMArtist.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class APMArtist: Artist, Equatable, Hashable {
    var name: String
    var genre: String
    var imageLink: URL?
    var id: String
    
    init(name: String, genre: String, imageLink: URL?, id: String) {
        self.name = name
        self.genre = genre
        self.imageLink = imageLink
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(genre)
    }
    
    static func == (lhs: APMArtist, rhs: APMArtist) -> Bool {
        return lhs.name == rhs.name
        && lhs.genre == rhs.genre
    }
    
    class func convert(
        results: APMSearch.APMSearchResults,
        imageWidth: Int = 200,
        imageHeight: Int = 200
    ) -> [APMArtist] {
        return
            results.artists?.data.map { artist -> APMArtist? in
            if let genre = artist.attributes.genreNames.first {
                    return APMArtist(name: artist.attributes.name,
                                     genre: genre,
                                     imageLink: artist.relationships.albums.data.first?
                                        .attributes?.artwork?
                                        .artworkImageURL(width: imageWidth, height: imageHeight),
                                     id: artist.id)
                }
                return nil
            }
            .compactMap { $0 } // remove all nil elements
            ?? []
    }
}
