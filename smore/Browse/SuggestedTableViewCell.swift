//
//  GenericBrowseTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher

class SuggestedTableViewCell: UITableViewCell {
    static let identifier = "suggestedTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var artists: [APMArtist] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.collectionViewLayout = FlowLayout(size: CGSize(width: 147, height: 202),
                                                         itemSpacing: 0, lineSpacing: 10, leftInset: 16.0)
        
    }
}

extension SuggestedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath)
        
        if let cell = cell as? PlaylistCollectionViewCell {
            cell.playlistImage.kf.setImage(with: artists[indexPath.row].imageLink,
                                           placeholder: UIImage(named: "artistPlaceholder"))
            cell.playlistName.text = artists[indexPath.row].name
            cell.subtitle.text = artists[indexPath.row].genre
        }
        
        return cell
    }
    
    
}
