//
//  APMGenre.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

public class APMGenre: Hashable, Equatable {
    
    let name: String
    let image: UIImage?
    let catalogGenre: APMCatalogGenre
    
    init(name: String, image: UIImage?, catalogGenre: APMCatalogGenre) {
        self.name = name
        self.image = image
        self.catalogGenre = catalogGenre
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(catalogGenre)
    }
    
    public static func == (lhs: APMGenre, rhs: APMGenre) -> Bool {
        return lhs.name == rhs.name && lhs.catalogGenre == rhs.catalogGenre
    }
    
    static let defaultGenres: [APMGenre] = {
        var genres = [APMGenre]()
        
        genres.append(APMGenre(name: "Pop", image: UIImage(named: "pop"), catalogGenre: .pop))
        genres.append(APMGenre(name: "Alternative", image: UIImage(named: "alternative"), catalogGenre: .alternative))
        genres.append(APMGenre(name: "Blues", image: UIImage(named: "blues"), catalogGenre: .blues))
        genres.append(APMGenre(name: "Children's Music", image: UIImage(named: "childrens_music"), catalogGenre: .children))
        genres.append(APMGenre(name: "Holiday", image: UIImage(named: "christmas_carols"), catalogGenre: .holiday))
        genres.append(APMGenre(name: "Classical", image: UIImage(named: "classical"), catalogGenre: .classical))
        genres.append(APMGenre(name: "Country", image: UIImage(named: "country"), catalogGenre: .country))
        genres.append(APMGenre(name: "Electronic", image: UIImage(named: "edm"), catalogGenre: .electronic))
        genres.append(APMGenre(name: "World", image: UIImage(named: "world"), catalogGenre: .world))
        genres.append(APMGenre(name: "Gospel", image: UIImage(named: "gospel"), catalogGenre: .christianGospel))
        genres.append(APMGenre(name: "Singer & Songwriter", image: UIImage(named: "indie"), catalogGenre: .singerSongwriter))
        genres.append(APMGenre(name: "Jazz", image: UIImage(named: "jazz"), catalogGenre: .jazz))
        genres.append(APMGenre(name: "Latin", image: UIImage(named: "latin"), catalogGenre: .latino))
        genres.append(APMGenre(name: "R&B", image: UIImage(named: "R&B"), catalogGenre: .rnbSoul))
        genres.append(APMGenre(name: "Hip Hop & Rap", image: UIImage(named: "hip_hop"), catalogGenre: .hipHopRap))
        genres.append(APMGenre(name: "Rock", image: UIImage(named: "rock"), catalogGenre: .rock))
        genres.append(APMGenre(name: "Reggae", image: UIImage(named: "reggae"), catalogGenre: .reggae))
        //("Metal", UIImage(named: "metal")!),
        return genres
    }()
}
