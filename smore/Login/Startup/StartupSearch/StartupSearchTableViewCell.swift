//
//  StartupSearchTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class StartupSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var startupCellImageView: UIImageView!
    @IBOutlet weak var startupCellMasterLabel: UILabel!
    @IBOutlet weak var startupCellDetailLabel: UILabel!
    
    static let identifier = "startupSearchTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startupCellImageView.addRoundCorners(cornerRadius: 5.0)
    }    
}
