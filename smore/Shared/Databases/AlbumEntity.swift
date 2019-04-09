//
//  AlbumEntity.swift
//  smore
//
//  Created by Jing Wei Li on 4/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import CoreData

class AlbumEntity: NSManagedObject {
    
    static var context = SmoreDatabase.context
    
    static let fetchedResultsController: NSFetchedResultsController<AlbumEntity> = {
        let request: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return frc
    }()

    @discardableResult
    class func makeAlbum(with album: Album, save: Bool = true) -> AlbumEntity {
        guard !album.songs.isEmpty else { fatalError("Album should have songs when adding to DB")}
        let albumEntity = AlbumEntity(context: context)
        albumEntity.artistName = album.artistName
        albumEntity.name = album.name
        albumEntity.id = album.id
        albumEntity.playableString = album.playableString
        albumEntity.imageLink = album.imageLink
        albumEntity.originalImageLink = album.originalImageLink
        albumEntity.releaseDate = album.releaseDate
        albumEntity.editorDescription = album.description
        albumEntity.streamingService = Int16(album.streamingService.rawValue)
        albumEntity.isSingle = album.isSingle
        
        albumEntity.addToSongs(NSOrderedSet(array: album.songs.map {
            SongEntity.makeSong(from: $0, save: false)
        }))
        
        if context.hasChanges && save { try? context.save() }
        
        return albumEntity
    }
    
    class func albums() -> [Album] {
        let request: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        if let results = try? context.fetch(request) {
            return results.reduce([], { tempResult, newEntity -> [Album] in
                if let streamingService = StreamingService(rawValue: Int(newEntity.streamingService)) {
                    switch streamingService {
                    case .appleMusic:
                        return tempResult + [APMAlbum(albumEntity: newEntity)]
                    default: break
                    }
                }
                return tempResult
            })
        }
        return []
    }
    
    class func doesAlbumExist(album: Album) -> Bool {
        let request: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && artistName = %@ && id = %@",
            album.name, album.artistName, album.id)
        if let results = try? context.fetch(request), !results.isEmpty {
            return true
        }
        return false
    }
    
    class func standardAlbum(from entity: AlbumEntity) -> Album? {
        if let streamingService = StreamingService(rawValue: Int(entity.streamingService)) {
            switch streamingService {
            case .appleMusic:
                return APMAlbum(albumEntity: entity)
            default: break
            }
        }
        return nil
    }
}
