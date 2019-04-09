//
//  TestAlbumEntity.swift
//  smoreTests
//
//  Created by Jing Wei Li on 4/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import XCTest
import CoreData

class TestAlbumEntity: XCTestCase {
    var album: APMAlbum!
    var entity: AlbumEntity!
    
    let imagelink = """
        https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/bf/48/b7/bf48b7cb-6886-b77d-dbd5-c4999cd2a739/884977157031.jpg/300x300bb.jpeg
        """
    
    let originalImageLink = """
        https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/bf/48/b7/bf48b7cb-6886-b77d-dbd5-c4999cd2a739/884977157031.jpg/{w}x{h}bb.jpeg
        """
    
    let editorDescription = "Springsteen's third album was the one that broke it all open for him, planting his tales of Jersey girls, cars, and nights spent sleeping on the beach firmly in the Top Five. He shot for an unholy hybrid of Orbison, Dylan and Spector — and actually reached it. \"Come take my hand,\" he invited in the opening lines. \"We're ridin' out tonight to case the Promised Land.\" Soon after this album, he'd discover the limits of such dreams, but here, it's a wide-open road: Even the tales of petty crime (\"Meeting Across the River\") and teen-gang violence (\"Jungleland\") are invested with all the wit and charm you can handle. Bruce's catalog is filled with one-of-a-kind albums from <i>The Wild, The Innocent and the E Street Shuffle</i> to <i>The Ghost of Tom Joad</i>. Forty years on, <i>Born to Run</i> still sits near the very top of that stack."
    
    override func setUp() {
        super.setUp()
        
        if let path = Bundle(for: type(of: self)).path(forResource: "SampleAlbumData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let response = try JSONDecoder().decode(APMAlbumResponse.self, from: data)
                guard let firstData = response.data.first else {
                    throw NSError(domain: "Invalid Response", code: 0, userInfo: nil)
                }
                album = APMAlbum(albumResponse: firstData)
                AlbumEntity.context = NSManagedObjectContext.contextForTests(using: Bundle(for: type(of: self)))
                
                let request: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
                request.predicate = NSPredicate(value: true)
                let results = try AlbumEntity.context.fetch(request)
                results.forEach { AlbumEntity.context.delete($0) }
                entity = AlbumEntity.makeAlbum(with: album, save: false)
                if AlbumEntity.context.hasChanges { try AlbumEntity.context.save() }
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
    }

    func testEntityCreation() {
        XCTAssertTrue(AlbumEntity.doesAlbumExist(album: album))
        XCTAssertEqual(entity.artistName!, "Bruce Springsteen")
        XCTAssertEqual(entity.name, "Born to Run")
        XCTAssertEqual(entity.id, "310730204")
        XCTAssertEqual(entity.playableString, "310730204")
        XCTAssertEqual(entity.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(entity.originalImageLink!, originalImageLink)
        XCTAssertEqual(entity.releaseDate, "1975-08-25")
        XCTAssertEqual(entity.editorDescription!, editorDescription)
        XCTAssertEqual(entity.streamingService, 0)
        XCTAssertEqual(entity.isSingle, false)
        XCTAssertEqual(entity.songs!.count, 8)
    }
    
    func testAlbumConversion() {
        let albums = AlbumEntity.albums()
        XCTAssertEqual(1, albums.count, "Wrong length")
        guard let currentAlbum = albums.first else {
            XCTFail("Unexpected")
            return
        }
        
        XCTAssertEqual(currentAlbum.artistName, "Bruce Springsteen")
        XCTAssertEqual(currentAlbum.name, "Born to Run")
        XCTAssertEqual(currentAlbum.id, "310730204")
        XCTAssertEqual(currentAlbum.playableString, "310730204")
        XCTAssertEqual(currentAlbum.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(currentAlbum.originalImageLink!, originalImageLink)
        XCTAssertEqual(currentAlbum.releaseDate, "1975-08-25")
        XCTAssertEqual(currentAlbum.description!, editorDescription)
        XCTAssertEqual(currentAlbum.streamingService, .appleMusic)
        XCTAssertEqual(currentAlbum.isSingle, false)
        XCTAssertEqual(currentAlbum.songs.count, 8)
        
    }
    
    func testStandardAlbum() {
        guard let currentAlbum = AlbumEntity.standardAlbum(from: entity) else {
            XCTFail("Standard Album Converison failed")
            return
        }
        
        XCTAssertEqual(currentAlbum.artistName, "Bruce Springsteen")
        XCTAssertEqual(currentAlbum.name, "Born to Run")
        XCTAssertEqual(currentAlbum.id, "310730204")
        XCTAssertEqual(currentAlbum.playableString, "310730204")
        XCTAssertEqual(currentAlbum.imageLink!, URL(string: imagelink)!)
        XCTAssertEqual(currentAlbum.originalImageLink!, originalImageLink)
        XCTAssertEqual(currentAlbum.releaseDate, "1975-08-25")
        XCTAssertEqual(currentAlbum.description!, editorDescription)
        XCTAssertEqual(currentAlbum.streamingService, .appleMusic)
        XCTAssertEqual(currentAlbum.isSingle, false)
        XCTAssertEqual(currentAlbum.songs.count, 8)
    }

}
