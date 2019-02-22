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
    
    override init() {
        super.init()
    }
    
    func fetchData(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        AppleMusicAPI.topCharts(for: [.albums], genre: .alternative, completion: { [weak self] results in
            let artists = results.albums?.first?.data.map { album in
                return APMArtist(name: album.attributes.artistName,
                                 genre: album.attributes.genreNames.first ?? "" ,
                                 imageLink: album.attributes.artwork.artworkImageURL(),
                                 id: "")
            } ?? []
            self?.artists = artists.duplicatesRemoved()
            self?.genres = APMGenre.defaultGenres
            DispatchQueue.main.async {
                completion()
            }
        }, error: { err in
            error(err)
        })
    }

}
