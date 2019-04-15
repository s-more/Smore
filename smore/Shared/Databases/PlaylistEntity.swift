//
//  PlaylistEntity.swift
//  smore
//
//  Created by Jing Wei Li on 4/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import CoreData

class PlaylistEntity: NSManagedObject {
    
    static let fetchedResultsController: NSFetchedResultsController<PlaylistEntity> = {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: SmoreDatabase.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return frc
    }()
    
    class func makePlaylist(with playlist: Playlist) {
        guard !playlist.songs.isEmpty else { fatalError("Playlist should have songs when adding to DB")}
        
        let playlistEntity = PlaylistEntity(context: SmoreDatabase.context)
        playlistEntity.id = playlist.id
        playlistEntity.name = playlist.name
        playlistEntity.curatorName = playlist.curatorName
        playlistEntity.playableString = playlist.playableString
        playlistEntity.originalImageLink = playlist.originalImageLink
        playlistEntity.imageLink = playlist.imageLink
        playlistEntity.streamingService = Int16(playlist.streamingService.rawValue)
        playlistEntity.editorDescription = playlist.description
        
        
        playlistEntity.addToSongs(NSOrderedSet(array: playlist.songs.map {
            SongEntity.makeSong(from: $0, save: false)
        }))
        
        try? SmoreDatabase.save()
    }
    
    class func add(song: Song, to playlist: Playlist) -> Error? {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && curatorName = %@ && id = %@",
            playlist.name, playlist.curatorName, playlist.id)
        do {
            let result = try SmoreDatabase.context.fetch(request)
            if result.count != 1 {
                return NSError(domain: "DB inconsistency or playlist do not exist in DB",
                               code: 0, userInfo: nil)
            }
            let entity = SongEntity.makeSong(from: song)
            result.first?.addToSongs(entity)
            try SmoreDatabase.save()
        } catch let error {
            return error
        }
        return nil
    }
    
    class func playlists() -> [Playlist] {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        if let results = try? SmoreDatabase.context.fetch(request) {
            return results.reduce([], { tempResult, newEntity -> [Playlist] in
                if let streamingService = StreamingService(rawValue: Int(newEntity.streamingService)) {
                    switch streamingService {
                    case .appleMusic:
                        return tempResult + [APMPlaylist(playlistEntity: newEntity)]
                    case .combined:
                        return tempResult + [CombinedPlaylist(playlistEntity: newEntity)]
                    case .spotify:
                        return tempResult + [SPTPlaylist(playlistEntity: newEntity)]
                    default: break
                    }
                }
                return tempResult
            })
        }
        return []
    }
    
    class func doesPlaylistExist(playlist: Playlist) -> Bool {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "name = %@ && curatorName = %@ && id = %@",
            playlist.name, playlist.curatorName, playlist.id)
        if let results = try? SmoreDatabase.context.fetch(request), !results.isEmpty {
            return true
        }
        return false
    }
    
    class func standardPlaylist(from entity: PlaylistEntity) -> Playlist? {
        if let streamingService = StreamingService(rawValue: Int(entity.streamingService)) {
            switch streamingService {
            case .appleMusic:
                return APMPlaylist(playlistEntity: entity)
            case .combined:
                return CombinedPlaylist(playlistEntity: entity)
            case .spotify:
                return SPTPlaylist(playlistEntity: entity)
            default: break
            }
        }
        return nil
    }
}
