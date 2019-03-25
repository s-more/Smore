//
//  PlaylistCollectionViewCell.swift
//  smore
//
//  Created by Colin Williamson on 2/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "playlistCollectionViewCell"

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    var isCircular = false {
        didSet {
            setCornerBehavior()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerBehavior()
    }
    
    func setCornerBehavior() {
        isCircular
            ? playlistImage.addRoundCorners(cornerRadius: bounds.width / 2)
            : playlistImage.addRoundCorners()
    }

}
