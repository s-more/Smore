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
    let leftInset: CGFloat
    
    init(size: CGSize, itemSpacing: CGFloat, lineSpacing: CGFloat, leftInset: CGFloat = 0) {
        self.size = size
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        self.leftInset = leftInset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 2)
        itemSize = size
        minimumInteritemSpacing = itemSpacing
        minimumLineSpacing = lineSpacing
        
    }
}


