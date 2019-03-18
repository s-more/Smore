//
//  PlayerViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/17/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import MarqueeLabel
import Kingfisher

class PlayerViewController: UIViewController {
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var remaningTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var subtitleLabel: MarqueeLabel!
    @IBOutlet weak var queueTableView: UITableView!
    @IBOutlet weak var albumArtCollectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    static let current = PlayerViewController()
    let viewModel: PlayerViewModel
    
    private init() {
        viewModel = PlayerViewModel()
        super.init(nibName: "PlayerViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queueTableView.delegate = self
        queueTableView.dataSource = self
        albumArtCollectionView.delegate = self
        albumArtCollectionView.dataSource = self
        scrollView.delegate = self
        
        queueTableView.register(UINib(nibName: "SongTableViewCell", bundle: Bundle.main),
                                forCellReuseIdentifier: SongTableViewCell.identifier)
        albumArtCollectionView.register(
            UINib(nibName: "PlayerAlbumArtCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: PlayerAlbumArtCollectionViewCell.identifier)
        let artworkHeight = albumArtCollectionView.bounds.height
        albumArtCollectionView.collectionViewLayout = FlowLayout(
            size: CGSize(width: artworkHeight, height: artworkHeight),
            itemSpacing: 30,
            lineSpacing: 30,
            inset: (UIScreen.main.bounds.width - artworkHeight) / 2)
        applyContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.isDismissing = false
        albumArtCollectionView.scrollToItem(at: IndexPath(row: MusicQueue.shared.currentPosition, section: 0), at: .left, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK - IBActions
    @IBAction func playOrPause(_ sender: UIButton) {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        
    }
    
    func applyContentSize() {
        let tableViewSize = CGSize(
            width: UIScreen.main.bounds.height,
            height: CGFloat(MusicQueue.shared.queue.value.count) * SongTableViewCell.preferredHeight)
        
        queueTableView.contentSize = tableViewSize
        tableViewHeight.constant = tableViewSize.height
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.height,
                                        height: tableViewSize.height - 10 + UIScreen.main.bounds.height)
        view.layoutIfNeeded()
    }
    
}

extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicQueue.shared.queue.value.count - MusicQueue.shared.currentPosition
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        let currentSong = MusicQueue.shared.queue.value[MusicQueue.shared.currentPosition + indexPath.row]
        if let cell = cell as? SongTableViewCell {
            cell.songImageView.kf.setImage(with: currentSong.imageLink,
                                           placeholder: UIImage(named: "artistPlaceholder"))
            cell.songSubtitle.text = currentSong.artistName
            cell.songTitle.text = currentSong.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongTableViewCell.preferredHeight
    }
}

extension PlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MusicQueue.shared.queue.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlayerAlbumArtCollectionViewCell.identifier, for: indexPath)
        
        if let cell = cell as? PlayerAlbumArtCollectionViewCell {
            cell.albumArtImageView.kf.setImage(with: MusicQueue.shared.queue.value[indexPath.row].imageLink,
                                                  placeholder: UIImage(named: "artistPlaceholder"))
        }
        return cell
    }
}

extension PlayerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !viewModel.isDismissing && scrollView.contentOffset.y < 0 {
            viewModel.isDismissing = true
            dismiss(animated: true, completion: nil)
        }
    }
}
