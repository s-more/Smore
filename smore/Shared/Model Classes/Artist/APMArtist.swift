//
//  APMArtist.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class APMArtist: Artist, Equatable, Hashable {
    var name: String
    var genre: String
    var imageLink: URL
    var id: String
    
    init(name: String, genre: String, imageLink: URL, id: String) {
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
}
