//
//  SongServiceIconTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 4/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SongServiceIconTableViewCell: UITableViewCell {
    
    static let identifier = "songServiceIconTableViewCell"
    static let preferredHeight: CGFloat = 60
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songSubtitle: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var serviceIconImageView: UIImageView!
    

    var song: Song?
    var didSelectMoreButton: ((Song) -> Void)?
    
    func configure(with song: Song) {
        songImageView.kf.setImage(with: song.imageLink, placeholder: UIImage(named: "artistPlaceholder"))
        songTitle.text = song.name
        songSubtitle.text = song.artistName
        serviceIconImageView.image = song.streamingService.icon
        self.song = song
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songImageView.addRoundCorners(cornerRadius: 5.0)
    }
    
    @IBAction func moreIconTapped(_ sender: UIButton) {
        if let song = song {
            didSelectMoreButton?(song)
        }
    }
}
