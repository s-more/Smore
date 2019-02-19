//
//  StartupViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher

class StartupViewController: UIViewController {
    @IBOutlet weak var favArtistCollectionView: UICollectionView!
    @IBOutlet weak var favGenreCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    let viewModel: StartupViewModel
    
    init() {
        viewModel = StartupViewModel()
        super.init(nibName: "StartupViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Start by picking:"
        favArtistCollectionView.delegate = self
        favArtistCollectionView.dataSource = self
        favGenreCollectionView.dataSource = self
        favGenreCollectionView.delegate = self
        
        doneButton.addDefaultGradient()
        doneButton.addRoundCorners()
        
        favArtistCollectionView.register(UINib(nibName: "StartupCollectionViewCell", bundle: Bundle.main),
                                         forCellWithReuseIdentifier: StartupCollectionViewCell.identifier)
        favGenreCollectionView.register(UINib(nibName: "StartupCollectionViewCell", bundle: Bundle.main),
                                        forCellWithReuseIdentifier: StartupCollectionViewCell.identifier)
        
        favArtistCollectionView.collectionViewLayout = FlowLayout(size: CGSize(width: 105, height: 140),
                                                                 itemSpacing: 0, lineSpacing: 10)
        
        viewModel.fetchData { [weak self] in
            self?.favArtistCollectionView.reloadData()
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
    }
}

extension StartupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favGenreCollectionView {
            return 0
        }
        // this is then the fav artist collection view
        return viewModel.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favGenreCollectionView {
            return UICollectionViewCell()
        }
        // this is then the fav artist collection view
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartupCollectionViewCell.identifier, for: indexPath) as? StartupCollectionViewCell {
            cell.startUpCellImage.kf.setImage(with: viewModel.artists[indexPath.row].imageLink,
                                              placeholder: UIImage(named: "artistPlaceholder"))
            cell.startupCellLabel.text = viewModel.artists[indexPath.row].name
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}
