//
//  Song.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol Song {
    var name: String { get set }
    var genre: String { get set }
    var imageLink: URL? { get set }
    var originalImageLink: String? { get set }
    var id: String { get set }
    var playableString: String { get set }
    var artistName: String { get set }
}
