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
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmoreDatabase")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    class func favArtists() -> [APMArtist] {
        let request: NSFetchRequest<APMArtistEntity> = APMArtistEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let results = try? persistentContainer.viewContext.fetch(request) {
            return results.map { APMArtist(
                name: $0.name ?? "",
                genre: $0.genre ?? "",
                imageLink: URL(string: $0.imageLink ?? ""),
                id: $0.identifier ?? "")
            }
        }
        return []
    }
    
    class func createArtists(from favArtists: [APMArtist]) {
        favArtists.forEach { makeArtistInstance(with: $0) }
        try? persistentContainer.viewContext.save()
    }
    
    private class func makeArtistInstance(with artist: APMArtist) {
        let newArtist = APMArtistEntity(context: persistentContainer.viewContext)
        newArtist.genre = artist.genre
        newArtist.identifier = artist.id
        newArtist.imageLink = artist.imageLink?.absoluteString ?? ""
        newArtist.name = artist.name
    }
}
