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
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var subtitleLabel: MarqueeLabel!
    @IBOutlet weak var queueTableView: UITableView!
    @IBOutlet weak var albumArtCollectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    let viewModel: PlayerViewModel
    let disposeBag = DisposeBag()
    
    private lazy var checkmarkAnimation: () -> Void = { [weak self] in
        self?.view.addSubview(LottieActivityIndicator.checkmark)
    }
    
    init() {
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
        
        progressSlider.setThumbImage(UIImage(named: "smoreSliderThumb"), for: .normal)
        progressSlider.isContinuous = false
        currentTimeLabel.text = "0:00"
        if let nowPlayingItemTime = Player.shared.nowPlayingItemPlaybackTime {
            remainingTimeLabel.text = Utilities.timeIntervalToReg(from: nowPlayingItemTime)
        }
        
        queueTableView.register(UINib(nibName: "SongTableViewCell", bundle: Bundle.main),
                                forCellReuseIdentifier: SongTableViewCell.identifier)
        albumArtCollectionView.register(
            UINib(nibName: "PlayerAlbumArtCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: PlayerAlbumArtCollectionViewCell.identifier)
        queueTableView.register(UINib(nibName: "BrowseHeader", bundle: Bundle.main),
                               forHeaderFooterViewReuseIdentifier: BrowseHeader.identifier)
        
        queueTableView.sectionHeaderHeight = UITableView.automaticDimension
        queueTableView.estimatedSectionHeaderHeight = 60
        
        let artworkHeight = albumArtCollectionView.bounds.height
        albumArtCollectionView.collectionViewLayout = FlowLayout(
            size: CGSize(width: artworkHeight, height: artworkHeight),
            itemSpacing: 30,
            lineSpacing: 30,
            inset: (UIScreen.main.bounds.width - artworkHeight) / 2)
        
        MusicQueue.shared.currentPosition.asObservable()
            .observeOn(MainScheduler.instance)
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
        shuffleButton.tintColor = Player.shared.shuffleModeTintColor
        repeatButton.tintColor = Player.shared.repeatModeTintColor
        queueTableView.reloadData()
        albumArtCollectionView.reloadData()
        
        if viewModel.timer == nil {
            generatePlaybackUpdateTimer()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.applyContentSize()
            strongSelf.viewModel.horizontalPosition = strongSelf.scrollView.contentOffset.x
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.timer?.invalidate()
        viewModel.timer = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBActions
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
        MiniPlayer.shared.resetLocation()
        dismiss(animated: true)
    }
    
    @IBAction func sliderSlided(_ sender: UISlider) {
        if let totalTime = Player.shared.nowPlayingItemPlaybackTime {
            Player.shared.setCurrentPlaybackTime(with: Double(sender.value) * totalTime)
        }
    }
    
    @IBAction func repeatButtonTapped(_ sender: UIButton) {
        Player.shared.toggleRepeatMode()
        repeatButton.tintColor = Player.shared.repeatModeTintColor
    }
    
    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        Player.shared.toggleShuffleMode(completion: { [weak self] in
            self?.albumArtCollectionView.reloadData()
            self?.shuffleButton.tintColor = Player.shared.shuffleModeTintColor
        }, error: { error in
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: error.localizedDescription)
        })
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        UIAlertController.showMoreAction(from: MusicQueue.shared.currentSong, on: self)
    }
    
    // MARK: - Helpers
    
    func applyContentSize() {
        let tableViewSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat(MusicQueue.shared.queue.value.count - MusicQueue.shared.currentPosition.value) * SongTableViewCell.preferredHeight)
        
        scrollView.contentSize = CGSize(width: tableViewSize.width,
                                        height: tableViewSize.height + 30 + UIScreen.main.bounds.height)
        queueTableView.contentSize = tableViewSize
        tableViewHeight.constant = tableViewSize.height
        view.layoutIfNeeded()
    }
    
    func refresh() {
        titleLabel.text = MusicQueue.shared.currentSong.name
        subtitleLabel.text = MusicQueue.shared.currentSong.artistName
        albumArtCollectionView.scrollToItem(at: IndexPath(row: MusicQueue.shared.currentPosition.value, section: 0), at: .centeredHorizontally, animated: true)
        queueTableView.reloadData()
        applyContentSize()
    }
    
    // MARK: - Private
    func generatePlaybackUpdateTimer() {
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.remainingTimeLabel.text = Player.shared.remainingPlaybackTime
            self?.currentTimeLabel.text = Player.shared.currentPlaybackTime
            self?.progressSlider.setValue(Player.shared.currentPlaybackPercentage, animated: false)
        }
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
            cell.didSelectMoreButton = { [weak self] song in
                guard let strongSelf = self else { return }
                UIAlertController.showMoreAction(from: song, on: strongSelf)
            }
            cell.configure(with: currentSong)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicQueue.shared.currentPosition.value += (indexPath.row + 1)
        Player.shared.skipToCurrentPosition()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: BrowseHeader.identifier) as? BrowseHeader
        cell?.titleLabel.text = "Up next"
        return cell
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
            let song = MusicQueue.shared.queue.value[indexPath.row]
            cell.albumArtImageView.kf.setImage(
                with: Utilities.highResImage(
                    from: song.originalImageLink, width: Int(cell.bounds.width * 0.8)),
                placeholder: UIImage(named: "artistPlaceholder"))
        }
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == albumArtCollectionView {
            if viewModel.scrollDirectioon == .right { // scrolled right
                Player.shared.skipToNext()
            } else if viewModel.scrollDirectioon == .left { // scrolled left
                if !Player.shared.skipToPrev() {
                    albumArtCollectionView.scrollToItem(
                        at: IndexPath(row: MusicQueue.shared.currentPosition.value, section: 0),
                        at: .centeredHorizontally, animated: true)
                }
            }
            viewModel.horizontalPosition = scrollView.contentOffset.x
        } else if scrollView == self.scrollView {
            if scrollView.contentOffset.y < -20 && !viewModel.isDismissing {
                viewModel.isDismissing = true
                MiniPlayer.shared.resetLocation()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == albumArtCollectionView else { return }
        if scrollView.contentOffset.x > viewModel.horizontalPosition {
            viewModel.scrollDirectioon = .right
        } else if scrollView.contentOffset.x < viewModel.horizontalPosition { // scrolled left
            viewModel.scrollDirectioon = .left
        }
        viewModel.horizontalPosition = scrollView.contentOffset.x
    }
}

