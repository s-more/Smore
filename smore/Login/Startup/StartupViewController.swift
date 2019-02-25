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
        favGenreCollectionView.collectionViewLayout = FlowLayout(size: CGSize(width: 105, height: 140),
                                                                 itemSpacing: 0, lineSpacing: 10)
        
        let activityIndicator = LottieActivityIndicator(animationName: "StrugglingAnt")
        view.addSubview(activityIndicator)
        
        viewModel.fetchData(completion: { [weak self] in
            activityIndicator.stop()
            self?.favArtistCollectionView.reloadData()
            self?.favGenreCollectionView.reloadData()
        }, error: { error in
            activityIndicator.stop()
            print(error.localizedDescription)
        })
        
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        UserDefaults.setFirstLaunch()
        viewModel.storeUserPreferences()
        let tabBarVC = TabBarViewController()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = tabBarVC
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = StartupSearchTableViewController()
        searchVC.completion = { [weak self] artist in
            self?.viewModel.artists.insert(artist, at: 0)
            self?.favArtistCollectionView.reloadData()
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

extension StartupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favGenreCollectionView {
            return viewModel.genres.count
        }
        // this is then the fav artist collection view
        return viewModel.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartupCollectionViewCell.identifier, for: indexPath) as? StartupCollectionViewCell {
            if collectionView == favGenreCollectionView {
                cell.startUpCellImage.image = viewModel.genres[indexPath.row].image
                cell.startupCellLabel.text = viewModel.genres[indexPath.row].name
            } else {
                // this is then the fav artist collection view
                cell.startUpCellImage.kf.setImage(with: viewModel.artists[indexPath.row].imageLink,
                                                  placeholder: UIImage(named: "artistPlaceholder"))
                cell.startupCellLabel.text = viewModel.artists[indexPath.row].name
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == favGenreCollectionView {
            let cell = favGenreCollectionView.cellForItem(at: indexPath) as? StartupCollectionViewCell
            if cell?.isChoosen ?? false {
                cell?.startUpCellImage.layer.borderWidth = 0
                cell?.startUpCellImage.layer.borderColor = UIColor.clear.cgColor
                viewModel.removeFromSelectedGenres(with: viewModel.genres[indexPath.row])
                cell?.isChoosen = false
            } else {
                cell?.startUpCellImage.layer.borderWidth = 2.0
                cell?.startUpCellImage.layer.borderColor = UIColor.themeColor.cgColor
                viewModel.selectedGenre.append(viewModel.genres[indexPath.row])
                cell?.isChoosen = true
            }
        } else { // artists
            let cell = favArtistCollectionView.cellForItem(at: indexPath) as? StartupCollectionViewCell
            if cell?.isChoosen ?? false {
                cell?.startUpCellImage.layer.borderWidth = 0.0
                cell?.startUpCellImage.layer.borderColor = UIColor.clear.cgColor
                viewModel.removeFromSelectedArtists(with: viewModel.artists[indexPath.row])
                cell?.isChoosen = false
            } else {
                cell?.startUpCellImage.layer.borderWidth = 2.0
                cell?.startUpCellImage.layer.borderColor = UIColor.themeColor.cgColor
                viewModel.selectedArtist.append(viewModel.artists[indexPath.row])
                cell?.isChoosen = true
            }
        }
    }
}
