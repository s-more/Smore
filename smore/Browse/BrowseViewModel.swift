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
    var recTracks: [SPTSong] = []
    var headers: [String] = []
    var recentPlayedData: [Any] = []
    var recommendations: [Any] = []
    
    init() {
        self.favGenres = UserDefaults.favGenres
        favArtists = []
        topCharts = []
    }
    
    func fetchData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        if FeatureFlags.appleMusicEnabled {
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
                            if FeatureFlags.spotifyEnabled {
                                SpotifyAPI.getTopArtists(token: SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? "", typeIsArtist: "artists", limit: 5, completion: { topData in
                                    SpotifyAPI.getRecArtists(token: SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? "", artistSeeds: topData.items ?? [], completion: { recData in
                                        self?.recTracks = recData.tracks?.map { SPTSong(recTracks: $0) } ?? []
                                        self?.headers = [
                                            "What would you like to listen to?", "Top Charts", "Recent Played", "Apple Music Recommendations", "Spotify Recommendations"
                                        ]
                                        DispatchQueue.main.async { completion() }
                                    }, error: {e1 in
                                        DispatchQueue.main.async { error(e1) }
                                    })
                                    DispatchQueue.main.async { completion() }
                                }, error: {e2 in
                                    DispatchQueue.main.async { error(e2) }
                                })
                            } else {
                                self?.headers = [
                                    "What would you like to listen to?", "Top Charts", "Recent Played", "Apple Music Recommendations"
                                ]
                            }
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
        } else {
            if FeatureFlags.spotifyEnabled {
                AppleMusicAPI.topCharts(
                    for: [.songs],
                    genre: favGenres.first ?? .alternative,
                    completion: { [weak self] results in
                        self?.topCharts = results.songs?.first?.data.map { data in
                            return APMSong(response: data)
                            } ?? []
                        self?.favArtists = APMArtistEntity.favArtists()
//                        self?.headers = ["What would you like to listen to?", "Top Charts", "Recent Played"]
                        SpotifyAPI.getTopArtists(token: SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? "", typeIsArtist: "artists", limit: 5, completion: { topData in
                            SpotifyAPI.getRecArtists(token: SpotifyRemote.shared.appRemote.connectionParameters.accessToken ?? "", artistSeeds: topData.items ?? [], completion: { recData in
                                self?.recTracks = recData.tracks?.map { SPTSong(recTracks: $0) } ?? []
                                self?.headers = [
                                    "What would you like to listen to?", "Top Charts", "Spotify Recommendations"
                                ]
                                DispatchQueue.main.async { completion() }
                            }, error: {e1 in
                                DispatchQueue.main.async { error(e1) }
                            })
                            DispatchQueue.main.async { completion() }
                        }, error: {e2 in
                            DispatchQueue.main.async { error(e2) }
                        })
                        DispatchQueue.main.async { completion() }
                    }, error: { e in
                        DispatchQueue.main.async { error(e) }
                })
            } else {
                AppleMusicAPI.topCharts(
                    for: [.songs],
                    genre: favGenres.first ?? .alternative,
                    completion: { [weak self] results in
                        self?.topCharts = results.songs?.first?.data.map { data in
                            return APMSong(response: data)
                            } ?? []
                        self?.favArtists = APMArtistEntity.favArtists()
                        self?.headers = ["What would you like to listen to?", "Top Charts", "Recent Played"]
                        
                        DispatchQueue.main.async { completion() }
                    }, error: { e in
                        DispatchQueue.main.async { error(e) }
                })
            }
        }
    }
}
