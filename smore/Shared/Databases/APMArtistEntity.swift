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
    
    static let fetchedResultsController: NSFetchedResultsController<APMArtistEntity> = {
        let request: NSFetchRequest<APMArtistEntity> = APMArtistEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: SmoreDatabase.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return frc
    }()
    
    class func favArtists() -> [Artist] {
        let request: NSFetchRequest<APMArtistEntity> = APMArtistEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let results = try? SmoreDatabase.context.fetch(request) {
            return results.map { APMArtist(
                name: $0.name ?? "",
                genre: $0.genre ?? "",
                imageLink: URL(string: $0.imageLink ?? ""),
                originalImageLink: $0.originalImageLink,
                id: $0.identifier ?? "")
            }
        }
        return []
    }
    
    class func doesArtistExist(artist: Artist) -> Bool {
        let request: NSFetchRequest<APMArtistEntity> = APMArtistEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && genre = %@ && identifier = %@",
            artist.name, artist.genre, artist.id)
        if let results = try? SmoreDatabase.context.fetch(request), !results.isEmpty {
            return true
        }
        return false
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
        newArtist.originalImageLink = artist.originalImageLink
        newArtist.streamingService = Int16(artist.streamingService.rawValue)
    }
}
