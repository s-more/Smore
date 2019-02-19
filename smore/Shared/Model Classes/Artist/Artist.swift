//
//  Artist.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol Artist {
    var name: String { get set }
    var genre: String { get set }
    var imageLink: URL { get set }
    var id: String { get set }
}
