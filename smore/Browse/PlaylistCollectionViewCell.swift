//
//  PlaylistCollectionViewCell.swift
//  smore
//
//  Created by Vignesh Babu on 2/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "playlistCollectionViewCell"

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playlistImage.addRoundCorners()

    }

}
