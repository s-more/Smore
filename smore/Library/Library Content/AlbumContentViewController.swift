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
        subtitleLabel.text = album.artistName
        serviceIcon.image = album.streamingService.icon
        tableView.register(UINib(nibName: "NumberedSongTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: NumberedSongTableViewCell.identifier)
        
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
            cell.songNumber.text = "\(album.songs[indexPath.row].trackNumber)"
            cell.songTitle.text = album.songs[indexPath.row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NumberedSongTableViewCell.preferredHeight
    }
    
    override func handleMoreButtonTap(_ sender: UIButton) {
        descriptionLabel.text = album.description
        super.handleMoreButtonTap(sender)
    }
    
    override var tableViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: CGFloat(album.songs.count * Int(NumberedSongTableViewCell.preferredHeight)))
    }
}
