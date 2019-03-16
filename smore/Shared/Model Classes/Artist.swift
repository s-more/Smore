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
    var imageLink: URL? { get set }
    var originalImageLink: String? { get set }
    var id: String { get set }
    var albums: [Album] { get set }
    var streamingService: StreamingService { get set }
    
    /// fetch all albums from this artist.
    /// - once done with the web request just assign the returned albums to `albums`.
    func albums(completion: @escaping () -> Void, error: @escaping (Error) -> Void)
}
