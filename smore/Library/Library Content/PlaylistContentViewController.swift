//
//  PlaylistContentViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class PlaylistContentViewController: LibraryContentViewController {
    
    let viewModel: PlaylistContentViewModel
    let ai = LottieActivityIndicator(animationName: "StrugglingAnt")
    
    init(viewModel: PlaylistContentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        navigationItem.title = viewModel.playlist.name
        artworkImage.kf.setImage(with: viewModel.highResImageURL,
                                 placeholder: UIImage.imageFrom(color: UIColor.black))
        titleLabel.text = viewModel.playlist.name
        subtitleLabel.text = viewModel.playlist.curatorName
        serviceIcon.image = viewModel.playlist.streamingService.icon
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SongTableViewCell.identifier)
        
        super.viewDidLoad()
        
        view.addSubview(ai)
        viewModel.prepareData(completion: { [weak self] in
            self?.ai.stop()
            if let prefix = self?.descriptionPrefix(from: self?.viewModel.playlist.description) {
                self?.descriptionLabel.text = prefix + " ... "
                self?.moreButton.isHidden = false
            } else {
                self?.descriptionLabel.text = self?.viewModel.playlist.description
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
        return viewModel.playlist.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? SongTableViewCell {
            cell.songImageView.kf.setImage(with: viewModel.playlist.songs[indexPath.row].imageLink,
                                           placeholder: UIImage(named: "artistPlaceholder"))
            cell.songTitle.text = viewModel.playlist.songs[indexPath.row].name
            cell.songSubtitle.text = viewModel.playlist.songs[indexPath.row].artistName
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongTableViewCell.preferredHeight
    }
    
    override func handleMoreButtonTap(_ sender: UIButton) {
        descriptionLabel.text = viewModel.playlist.description
        super.handleMoreButtonTap(sender)
    }
    
    override var tableViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: CGFloat(viewModel.playlist.songs.count * Int(SongTableViewCell.preferredHeight)))
    }

}
