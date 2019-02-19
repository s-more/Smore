//
//  StartupViewModel.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class StartupViewModel: NSObject {
    var genres: [(String, UIImage)] = []
    var artists: [APMArtist] = []
    
    override init() {
        super.init()
    }
    
    func fetchData(completion: @escaping () -> Void) {
        AppleMusicAPI.topCharts(for: [.albums], genre: .alternative, completion: { [weak self] results in
            let artists = results.albums?.first?.data.map { album in
                return APMArtist(name: album.attributes.artistName,
                                 genre: album.attributes.genreNames.first ?? "" ,
                                 imageLink: album.attributes.artwork.artworkImageURL(),
                                 id: "")
            } ?? []
            self?.artists = Array(Set(artists)).sorted(by: { $0.name < $1.name })
            DispatchQueue.main.async {
                completion()
            }
        }, error: { error in
            print(error.localizedDescription)
        })
    }

}
