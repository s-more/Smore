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
    var recentPlayedData: [Any] = []
    var recommendations: [Any] = []
    
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
                self?.favArtists = APMArtistEntity.favArtists()
                
                // fetch recent played data
                AppleMusicAPI.recentPlayed(completion: { data in
                    let albums = data.compactMap { APMAlbum(recentPlayedData: $0) } as [Any]
                    let playlists = data.compactMap { APMPlaylist(recentPlayedData: $0) } as [Any]
                    self?.recentPlayedData = albums + playlists
                    
                    // fetch recommendations
                    AppleMusicAPI.recommendations(completion: { recommendations in
                        let recommendationAlbums =
                            recommendations.compactMap { APMAlbum(recommendationData: $0) } as [Any]
                        let recommendationPlaylists =
                            recommendations.compactMap { APMPlaylist(recommendationData: $0) } as [Any]
                        self?.recommendations = recommendationPlaylists + recommendationAlbums
                        self?.headers = [
                            "What would you like to listen to?", "Top Charts", "Recent Played", "Recommendations"
                        ]
                        DispatchQueue.main.async { completion() }
                    }, error: { e2 in
                        DispatchQueue.main.async { error(e2) }
                    })
                }, error: { e in
                    DispatchQueue.main.async { error(e) }
                })
                
                DispatchQueue.main.async { completion() }
            }, error: { e in
                DispatchQueue.main.async { error(e) }
            })
    }
}
