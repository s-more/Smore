//
//  smoreTests.swift
//  smoreTests
//
//  Created by Jing Wei Li on 1/27/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import XCTest
@testable import smore

class smoreTests: XCTestCase {

    func testDuplicatesRemoval() {
        let indexPaths = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 1),
            IndexPath(row: 1, section: 1),
            IndexPath(row: 2, section: 2)
        ]
        
        let indexPathsDupesRemoved = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 1),
            IndexPath(row: 2, section: 2)
        ]
        
        
        XCTAssertEqual(["Jack", "Jack" ,"Ember", "Amber", "Amber"].duplicatesRemoved(),
                       ["Jack", "Ember", "Amber"])
        XCTAssertEqual([1, 9, 8, 8, 7, 5, 3, 3].duplicatesRemoved(), [1, 9, 8, 7, 5, 3])
        XCTAssertEqual([String]().duplicatesRemoved(), [])
        XCTAssertEqual(indexPaths.duplicatesRemoved(), indexPathsDupesRemoved)
    }

}
