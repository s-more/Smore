//
//  GenericTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    static let identifier = "genericTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.backgroundColor = UIColor.clear
    }
    
}
