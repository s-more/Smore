//
//  StartupViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class StartupViewModel: NSObject {
    var artists: [APMArtist] = []
    var genres: [APMGenre] = []
    var selectedArtist: [APMArtist] = []
    var selectedGenre: [APMGenre] = []
    
    override init() {
        super.init()
    }
    
    func removeFromSelectedGenres(with genre: APMGenre) {
        selectedGenre = selectedGenre.filter { $0 != genre }
    }
    
    func removeFromSelectedArtists(with artist: APMArtist) {
        selectedArtist = selectedArtist.filter { $0 != artist }
    }
    
    func storeUserPreferences() {
        UserDefaults.setFavGenres(with: selectedGenre.map { $0.catalogGenre })
        APMArtistEntity.createArtists(from: selectedArtist)
    }
    
    func fetchData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        AppleMusicAPI.topCharts(for: [.albums], genre: .alternative, completion: { [weak self] results in
            let artists = results.albums?.first?.data.map { album in
                return APMArtist(name: album.attributes.artistName,
                                 genre: album.attributes.genreNames.first ?? "" ,
                                 imageLink: album.attributes.artwork.artworkImageURL(),
                                 originalImageLink: album.attributes.artwork.url,
                                 id: "")
            } ?? []
            self?.artists = Array(Set(artists))
            self?.genres = APMGenre.defaultGenres
            DispatchQueue.main.async {
                completion()
            }
        }, error: { err in
            error(err)
        })
    }

}
