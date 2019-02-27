//
//  APMArtistEntity.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreData

class APMArtistEntity: NSManagedObject {
    
    class func favArtists() -> [APMArtist] {
        let request: NSFetchRequest<APMArtistEntity> = APMArtistEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let results = try? SmoreDatabase.context.fetch(request) {
            return results.map { APMArtist(
                name: $0.name ?? "",
                genre: $0.genre ?? "",
                imageLink: URL(string: $0.imageLink ?? ""),
                id: $0.identifier ?? "")
            }
        }
        return []
    }
    
    class func createArtists(from favArtists: [Artist]) {
        favArtists.forEach { makeArtistInstance(with: $0) }
        try? SmoreDatabase.save()
    }
    
    private class func makeArtistInstance(with artist: Artist) {
        let newArtist = APMArtistEntity(context: SmoreDatabase.context)
        newArtist.genre = artist.genre
        newArtist.identifier = artist.id
        newArtist.imageLink = artist.imageLink?.absoluteString 
        newArtist.name = artist.name
    }
}
