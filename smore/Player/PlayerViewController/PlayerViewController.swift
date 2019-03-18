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
import RxSwift

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
    @IBOutlet weak var playButton: UIButton!
    
    static let current = PlayerViewController()
    let viewModel: PlayerViewModel
    let disposeBag = DisposeBag()
    
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
        
        MusicQueue.shared.currentPosition.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.refresh()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.isDismissing = false
        albumArtCollectionView.scrollToItem(at: IndexPath(row: MusicQueue.shared.currentPosition.value, section: 0), at: .centeredHorizontally, animated: true)
        
        titleLabel.text = MusicQueue.shared.currentSong.name
        subtitleLabel.text = MusicQueue.shared.currentSong.artistName
        playButton.setImage(Player.shared.state.image, for: .normal)
        queueTableView.reloadData()
        albumArtCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.applyContentSize()
            strongSelf.viewModel.horizontalPosition = strongSelf.scrollView.contentOffset.x
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK - IBActions
    @IBAction func playOrPause(_ sender: UIButton) {
        Player.shared.playOrPause()
        playButton.setImage(Player.shared.state.image, for: .normal)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        Player.shared.skipToNext()
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        Player.shared.skipToPrev()
    }
    
    @IBAction func downCaretTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func applyContentSize() {
        let tableViewSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat(MusicQueue.shared.queue.value.count) * SongTableViewCell.preferredHeight)
        
        scrollView.contentSize = CGSize(width: tableViewSize.width,
                                        height: tableViewSize.height - 10 + UIScreen.main.bounds.height)
        queueTableView.contentSize = tableViewSize
        tableViewHeight.constant = tableViewSize.height
        view.layoutIfNeeded()
    }
    
    func refresh() {
        titleLabel.text = MusicQueue.shared.currentSong.name
        subtitleLabel.text = MusicQueue.shared.currentSong.artistName
        albumArtCollectionView.scrollToItem(at: IndexPath(row: MusicQueue.shared.currentPosition.value, section: 0), at: .centeredHorizontally, animated: true)
        queueTableView.reloadData()
    }
    
}

extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicQueue.shared.queue.value.count - MusicQueue.shared.currentPosition.value - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        let currentSong = MusicQueue.shared.queue.value[MusicQueue.shared.currentPosition.value + indexPath.row + 1]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicQueue.shared.currentPosition.value += (indexPath.row + 1)
        Player.shared.skipToCurrentPosition()
        albumArtCollectionView.reloadData()
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // scrolled right
        guard scrollView == albumArtCollectionView else { return }
        print(String(format: "%.3f", scrollView.contentOffset.x))
        print(String(format: "%.3f", viewModel.horizontalPosition))
        if scrollView.contentOffset.x > viewModel.horizontalPosition {
            print("Skipped next")
            Player.shared.skipToNext()
            refresh()
        }
        if scrollView.contentOffset.x < viewModel.horizontalPosition { // scrolled left
            Player.shared.skipToPrev()
            print("Skipped prev")
            refresh()
        }
        viewModel.horizontalPosition = scrollView.contentOffset.x
    }
}

extension PlayerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
}
