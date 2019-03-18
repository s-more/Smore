//
//  PlayerAlbumArtCollectionViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/17/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlayerAlbumArtCollectionViewCell: UICollectionViewCell {
    static let identifier = "playerAlbumArtCollectionViewCell"
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumArtImageView.addRoundCorners()
    }

}
