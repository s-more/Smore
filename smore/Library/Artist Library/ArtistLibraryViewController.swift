//
//  ArtistLibraryViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher

class ArtistLibraryViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    let viewModel: ArtistLibraryViewModel
    
    init(viewModel: ArtistLibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArtistLibraryViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backgroundImage.kf.setImage(with: viewModel.artist.imageLink,
//                                    placeholder: UIImage(named: "artistPlaceholder"))
        nameLabel.text = viewModel.artist.name
        
        viewModel.prepareData(completion: { [weak self] in
            self?.reloadPagerTabStripView()
        }, error: { err in
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: err.localizedDescription)
        })
    }
    
    
    // MAR: - XLPagerTabStrip
    
    override func viewControllers(
        for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        if !viewModel.isDataReady { return [] }
        return []
    }
}

