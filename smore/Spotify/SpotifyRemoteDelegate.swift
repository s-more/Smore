//
//  SpotifyRemoteDelegate.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol SpotifyRemoteDelegate: class {
    func remote(spotifyRemote: SpotifyRemote, didAuthenticate status: Bool)
}
