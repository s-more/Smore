//
//  LibraryContentViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher

class PlaylistContentViewController: UIViewController {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomGradientHeight: NSLayoutConstraint!
    
    let viewModel: PlaylistContentViewModel
    let ai = LottieActivityIndicator(animationName: "StrugglingAnt")
    
    init(viewModel: PlaylistContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PlaylistContentViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.playlist.name
        artworkImage.kf.setImage(with: viewModel.highResImageURL,
                                placeholder: UIImage.imageFrom(color: UIColor.black))
        titleLabel.text = viewModel.playlist.name
        subtitleLabel.text = viewModel.playlist.curatorName
        serviceIcon.image = viewModel.playlist.streamingService.icon
        
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        tableView.register(UINib(nibName: "StartupSearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: StartupSearchTableViewCell.identifier)
        
        applyContentSize()
        
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        view.addSubview(ai)
        viewModel.prepareData(completion: { [weak self] in
            self?.ai.stop()
            self?.tableView.reloadData()
            self?.applyContentSize()
        }, error: { [weak self] err in
            self?.ai.stop()
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: err.localizedDescription)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 0
        bottomGradientHeight.constant = titleLabel.frame.size.height + 40
        view.layoutIfNeeded()
        
        viewModel.nameLabelPositon = titleLabel.frame.origin.y + titleLabel.frame.height
    }
    
    func applyContentSize() {
        scrollView.contentSize = viewModel.scrollViewContentSize
        tableView.contentSize = viewModel.tableViewContentSize
        tableViewHeight.constant = viewModel.tableViewContentSize.height
        view.layoutIfNeeded()
    }
}

extension PlaylistContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlist.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StartupSearchTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? StartupSearchTableViewCell {
            cell.startupCellImageView.kf.setImage(with: viewModel.playlist.songs[indexPath.row].imageLink,
                                                  placeholder: UIImage(named: "artistPlaceholder"))
            cell.startupCellMasterLabel.text = viewModel.playlist.songs[indexPath.row].name
            cell.startupCellDetailLabel.text = viewModel.playlist.songs[indexPath.row].artistName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StartupSearchTableViewCell.preferredHeight
    }
    
    
}

extension PlaylistContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let position = viewModel.nameLabelPositon {
            if scrollView.contentOffset.y > position && !viewModel.isNavBarShown {
                viewModel.isNavBarShown = true
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 1
                }
            }
            
            if scrollView.contentOffset.y < position && viewModel.isNavBarShown {
                viewModel.isNavBarShown = false
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 0
                }
            }
        }
    }
}
