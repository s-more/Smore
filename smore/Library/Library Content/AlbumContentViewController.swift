//
//  AlbumContentViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class AlbumContentViewController: LibraryContentViewController {
    let album: Album
    let ai = LottieActivityIndicator(animationName: "StrugglingAnt")
    
    init(album: Album) {
        self.album = album
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        navigationItem.title = album.name
        artworkImage.kf.setImage(with: Utilities.highResImage(from: album.originalImageLink),
                                 placeholder: UIImage.imageFrom(color: UIColor.black))
        titleLabel.text = album.name
        subtitleLabel.text = [album.artistName, album.releaseDate].joined(separator: " · ")
        serviceIcon.image = album.streamingService.icon
        tableView.register(UINib(nibName: "NumberedSongTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: NumberedSongTableViewCell.identifier)
        
        if AlbumEntity.doesAlbumExist(album: album) {
            disableAddButton()
        }
        
        super.viewDidLoad()
        
        view.addSubview(ai)
        
        album.songs(completion: { [weak self] in
            self?.ai.stop()
            if let prefix = self?.descriptionPrefix(from: self?.album.description) {
                self?.descriptionLabel.text = prefix + " ... "
                self?.moreButton.isHidden = false
            } else {
                self?.descriptionLabel.text = self?.album.description
            }
            self?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.applyContentSize()
            }
        }, error: { [weak self] err in
            self?.ai.stop()
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: err.localizedDescription)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberedSongTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? NumberedSongTableViewCell {
            cell.didSelectMoreButton = { [weak self] song in
                guard let strongSelf = self else { return }
                UIAlertController.showMoreAction(from: song, on: strongSelf)
            }
            cell.configure(with: album.songs[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NumberedSongTableViewCell.preferredHeight
    }
    
    override var tableViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: CGFloat(album.songs.count * Int(NumberedSongTableViewCell.preferredHeight)))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if album.songs[indexPath.row].streamingService == StreamingService.spotify {
            Player.shared.stop()
            SpotifyRemote.shared.appRemote.playerAPI?.play(album.songs[indexPath.row].playableString, callback: SpotifyRemote.shared.defaultCallback)
        }else {
            SpotifyRemote.shared.appRemote.playerAPI?.pause(SpotifyRemote.shared.defaultCallback)
            MiniPlayer.shared.configure(with: album.songs[indexPath.row])
            MusicQueue.shared.queue.value = Array(album.songs[indexPath.row ..< album.songs.count])
        }
    }
    
    // MARK - Button Taps
    
    override func handleMoreButtonTap(_ sender: UIButton) {
        descriptionLabel.text = album.description
        super.handleMoreButtonTap(sender)
    }
    
    override func handlePlaybuttonTap(_ sender: UIButton) {
        if let first = album.songs.first {
            MiniPlayer.shared.configure(with: first)
            MusicQueue.shared.queue.value = album.songs
        }
    }
    
    override func handleShuffleButtonTap(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let first = self?.album.songs.first, let shuffled = self?.album.songs.shuffled() {
                DispatchQueue.main.async {
                    MiniPlayer.shared.configure(with: first)
                    MusicQueue.shared.queue.value = shuffled
                }
            }
        }
    }
    
    override func handleAddButtonTap(_ sender: UIButton) {
        AlbumEntity.makeAlbum(with: album)
        disableAddButton()
        super.handleAddButtonTap(sender)
    }
    
    func disableAddButton() {
        addToLibraryButton.setTitle("  Added to Library  ", for: .normal)
        addToLibraryButton.alpha = 0.6
        addToLibraryButton.isEnabled = false
    }
}
