//
//  NumberedSongTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class NumberedSongTableViewCell: UITableViewCell {
    static let preferredHeight: CGFloat = 50
    static let identifier = "numberedSongTableViewCell"
    
    @IBOutlet weak var songNumber: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var song: Song?
    var didSelectMoreButton: ((Song) -> Void)?
    
    func configure(with song: Song) {
        songNumber.text = "\(song.trackNumber)"
        songTitle.text = "\(song.name)"
        self.song = song
    }
    
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        if let song = song {
            didSelectMoreButton?(song)
        }
    }
}
