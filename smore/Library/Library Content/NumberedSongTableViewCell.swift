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
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
}
