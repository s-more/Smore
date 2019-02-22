//
//  FlowLayout.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    let size: CGSize
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
    
    init(size: CGSize, itemSpacing: CGFloat, lineSpacing: CGFloat) {
        self.size = size
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        itemSize = size
        minimumInteritemSpacing = itemSpacing
        minimumLineSpacing = lineSpacing
        
    }
}


