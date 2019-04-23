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
                self?.headers = ["What would you like to listen to?", "Top Charts", "Recent Played"]

                // fetch recent played data
                AppleMusicAPI.recentPlayed(completion: { data in
                    let albumData: [APMAlbum] =  data.compactMap { APMAlbum(recentPlayedData: $0) }
                    let playlistData: [APMPlaylist] = data.compactMap { APMPlaylist(recentPlayedData: $0) }
                    self?.recentPlayedData = (albumData as [Any]) + (playlistData as [Any])
                    
                    let SPTToken = SpotifyRemote.shared.appRemote.connectionParameters.accessToken
                    
                    SpotifyAPI.getTopArtists(
                        token: SPTToken ?? "",
                        typeIsArtist: "artists",
                        limit: 20,
                        completion: { data in
                            completion()
                    }, error: {err in
                        error(err)
                    })
                    
                    DispatchQueue.main.async { completion() }
                }, error: { e in
                    DispatchQueue.main.async { error(e) }
                })
                
                DispatchQueue.main.async { completion() }
            }, error: { e in
                DispatchQueue.main.async { error(e) }
            })
    }
}
