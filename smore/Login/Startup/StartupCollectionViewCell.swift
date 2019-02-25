//
//  CollectionViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class StartupCollectionViewCell: UICollectionViewCell {
    static let identifier = "startupCollectionViewCell"
    
    @IBOutlet weak var startUpCellImage: UIImageView!
    @IBOutlet weak var startupCellLabel: UILabel!
    var isChoosen = false
    
    override func awakeFromNib() {
        startUpCellImage.layer.cornerRadius = bounds.width / 2
        startUpCellImage.clipsToBounds = true
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if isChoosen {
            startUpCellImage.layer.borderWidth = 2
            startUpCellImage.layer.borderColor = UIColor.themeColor.cgColor
        } else {
            startUpCellImage.layer.borderWidth = 0
            startUpCellImage.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    

}
