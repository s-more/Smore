//
//  TestAlbumEntity.swift
//  smoreTests
//
//  Created by Jing Wei Li on 4/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import XCTest
import CoreData

class TestSongEntity: XCTestCase {
    var song: APMSong!
    var entity: SongEntity!
    
    let imagelink = "https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/bf/48/b7/bf48b7cb-6886-b77d-dbd5-c4999cd2a739/884977157031.jpg/300x300bb.jpeg"
    
    let originalImageLink = "https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/bf/48/b7/bf48b7cb-6886-b77d-dbd5-c4999cd2a739/884977157031.jpg/{w}x{h}bb.jpeg"
    
    override func setUp() {
        super.setUp()
        
        if let path = Bundle(for: type(of: self)).path(forResource: "SampleSongData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let response = try JSONDecoder().decode(APMAlbumResponse.APMAlbumData.APMAlbumRelationships.APMAlbumTrack.APMAlbumTrackData.self, from: data)
                song = APMSong(albumTrackData: response)
                SongEntity.context = NSManagedObjectContext.contextForTests(using: Bundle(for: type(of: self)))
                
                let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
                request.predicate = NSPredicate(value: true)
                let results = try SongEntity.context.fetch(request)
                results.forEach { SongEntity.context.delete($0) }
                entity = SongEntity.makeSong(from: song)
                if SongEntity.context.hasChanges { try SongEntity.context.save() }
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
    }
    
    func testEntityCreation() {
        XCTAssertTrue(SongEntity.doesSongExist(song: song))
        XCTAssertEqual(entity.artistName!, "Bruce Springsteen")
        XCTAssertEqual(entity.name, "She's the One")
        XCTAssertEqual(entity.id, "310730220")
        XCTAssertEqual(entity.playableString, "310730220")
        XCTAssertEqual(entity.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(entity.originalImageLink!, originalImageLink)
    }
    
    func testSongConversion() {
        let songs = SongEntity.songs()
        XCTAssertEqual(1, songs.count, "Wrong length")
        guard let currentSong = songs.first else {
            XCTFail("Unexpected")
            return
        }
        
        XCTAssertEqual(currentSong.artistName, "Bruce Springsteen")
        XCTAssertEqual(currentSong.name, "She's the One")
        XCTAssertEqual(currentSong.id, "310730220")
        XCTAssertEqual(currentSong.playableString, "310730220")
        XCTAssertEqual(currentSong.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(currentSong.originalImageLink!, originalImageLink)
        
    }
    
    func testStandardSong() {
        guard let currentSong = SongEntity.standardSong(from: entity) else {
            XCTFail("Standard Song Converison failed")
            return
        }
        
        XCTAssertEqual(currentSong.artistName, "Bruce Springsteen")
        XCTAssertEqual(currentSong.name, "She's the One")
        XCTAssertEqual(currentSong.id, "310730220")
        XCTAssertEqual(currentSong.playableString, "310730220")
        XCTAssertEqual(currentSong.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(currentSong.originalImageLink!, originalImageLink)
    }
    
}
