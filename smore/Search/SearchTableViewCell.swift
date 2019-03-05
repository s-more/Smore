//
//  SearchTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "searchTableViewCell"
    static let preferredHeight: CGFloat = 90
    
    @IBOutlet weak var masterLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var masterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        masterImage.addRoundCorners(cornerRadius: 10)
        separatorInset = UIEdgeInsets(top: 0, left: 16 + masterImage.bounds.width, bottom: 0, right: 0)
    }
    
}
