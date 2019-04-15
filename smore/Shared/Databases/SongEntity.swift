//
//  SongEntity.swift
//  smore
//
//  Created by Jing Wei Li on 4/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import CoreData

class SongEntity: NSManagedObject {
    
    /// Can change the context for the setting of unit tests.
    static var context: NSManagedObjectContext = SmoreDatabase.context
    
    static let fetchedResultsController: NSFetchedResultsController<SongEntity> = {
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return frc
    }()
    
    /// Insert a new song into the database.
    /// Returns a new song if it doesn't exist yet
    /// otherwise return the existing song
    @discardableResult
    class func makeSong(from song: Song, save: Bool = true) -> SongEntity {
        // start a fetch request and return the existing song if found
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && artistName = %@ && id = %@",
            song.name, song.artistName, song.id)
        if let results = try? context.fetch(request), let first = results.first {
            return first
        }
        
        // otherwise create new sing
        let entity = SongEntity(context: context)
        entity.name = song.name
        entity.genre = song.genre
        entity.imageLink = song.imageLink
        entity.originalImageLink = song.originalImageLink
        entity.id = song.id
        entity.playableString = song.playableString
        entity.artistName = song.artistName
        entity.streamingService = Int16(song.streamingService.rawValue)
        entity.trackNumer = Int16(song.trackNumber)
        entity.duration = song.duration
        
        if save && context.hasChanges { try? context.save() }
        return entity
    }
    
    class func songs() -> [Song] {
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? context.fetch(request) {
            return results.reduce([], { tempResult, newEntity -> [Song] in
                if let streamingService = StreamingService(rawValue: Int(newEntity.streamingService)) {
                    switch streamingService {
                    case .appleMusic:
                        return tempResult + [APMSong(songEntity: newEntity)]
                    case .youtube:
                        return tempResult + [YTVideo(songEntity: newEntity)]
                    case .spotify:
                        return tempResult + [SPTSong(songEntity: newEntity)]
                    default: break
                    }
                }
                return tempResult
            })
        }
        return []
    }
    
    class func doesSongExist(song: Song) -> Bool {
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && artistName = %@ && id = %@",
            song.name, song.artistName, song.id)
        if let results = try? context.fetch(request), !results.isEmpty {
            return true
        }
        return false
    }
    
    class func standardSong(from entity: SongEntity) -> Song? {
        if let streamingService = StreamingService(rawValue: Int(entity.streamingService)) {
            switch streamingService {
            case .appleMusic:
                return APMSong(songEntity: entity)
            case .youtube:
                return YTVideo(songEntity: entity)
            case .spotify:
                return SPTSong(songEntity: entity)
            default: break
            }
        }
        return nil
    }
    
}
