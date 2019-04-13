//
//  SongTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher

class SongTableViewCell: UITableViewCell {
    static let identifier = "songTableViewCell"
    static let preferredHeight: CGFloat = 60
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songSubtitle: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var song: Song?
    var didSelectMoreButton: ((Song) -> Void)?
    
    func configure(with song: Song) {
        songImageView.kf.setImage(with: song.imageLink, placeholder: UIImage(named: "artistPlaceholder"))
        songTitle.text = song.name
        songSubtitle.text = song.artistName
        self.song = song
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songImageView.addRoundCorners(cornerRadius: 5.0)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        if let song = song {
            didSelectMoreButton?(song)
        }
    }
}
