//
//  BrowseViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class BrowseViewModel {
    let favGenres: [APMCatalogGenre]
    var favArtists: [Artist]
    var topCharts: [APMSong]
    var headers: [String] = []
    
    init() {
        self.favGenres = UserDefaults.favGenres
        favArtists = []
        topCharts = []
    }
    
    func fetchData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        AppleMusicAPI.topCharts(
            for: [.songs],
            genre: favGenres.first ?? .alternative,
            completion: { [weak self] results in
                self?.topCharts = results.songs?.first?.data.map { data in
                    return APMSong(response: data)
                } ?? []
                self?.headers = ["What would you like to listen to?", "Top Charts"]
                self?.favArtists = APMArtistEntity.favArtists()
                DispatchQueue.main.async { completion() }
            }, error: { e in
                DispatchQueue.main.async { error(e) }
            })
    }
}
