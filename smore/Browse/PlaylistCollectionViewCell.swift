//
//  PlaylistCollectionViewCell.swift
//  smore
//
//  Created by Vignesh Babu on 2/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addRoundCorners()

    }

}
