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
    @IBOutlet weak var addButton: UIButton!
    
    var song: Song?
    var animationBlock: (() -> Void)?
    
    func configure(with song: Song) {
        songNumber.text = "\(song.trackNumber)"
        songTitle.text = "\(song.name)"
        addButton.isHidden = SongEntity.doesSongExist(song: song)
        self.song = song
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let song = song {
            SongEntity.makeSong(from: song)
            addButton.isHidden = true
            animationBlock?()
        }
    }
}
