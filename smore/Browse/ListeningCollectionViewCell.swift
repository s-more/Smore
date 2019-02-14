//
//  ListeningCollectionViewCell.swift
//  smore
//
//  Created by Colin Williamson on 2/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class ListeningCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var listeningValue: UILabel!
    @IBOutlet weak var listeningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addRoundCorners()
        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 220/255, green: 148/255, blue: 11/255, alpha: 1),
            UIColor(red: 132/255, green: 87/255, blue: 64/255, alpha: 1)
        ]
        self.layer.insertSublayer(CAGradientLayer.gradient(colors: colors,
                                                                  frame: self.bounds), at: 0)
    }

}
