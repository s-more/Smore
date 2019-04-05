//
//  SongTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    static let identifier = "songTableViewCell"
    static let preferredHeight: CGFloat = 60
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songSubtitle: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songImageView.addRoundCorners(cornerRadius: 5.0)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // implement
    }
}
