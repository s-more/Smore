//
//  LibraryContentViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Kingfisher

class LibraryContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomGradientHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var addToLibraryButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    private var nameLabelPosition: CGFloat = 0
    private var isNavBarShown = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "LibraryContentViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreButton.isHidden = true
        
        moreButton.addTarget(self, action: #selector(handleMoreButtonTap(_:)), for: .touchUpInside)
        addToLibraryButton.addTarget(self, action: #selector(handleAddButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(handlePlaybuttonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(handleShuffleButtonTap(_:)), for: .touchUpInside)
        
        addToLibraryButton.addSmoreBoder()
        playButton.addSmoreBoder()
        shuffleButton.addSmoreBoder()
        
        descriptionLabel.text = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        
        applyContentSize()
        
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 0
        nameLabelPosition = titleLabel.frame.origin.y + titleLabel.frame.height
    }
    
    // MARK: - Final Methods
    
    final func applyContentSize() {
        let screenWidth = UIScreen.main.bounds.width
        let descripHeight = descriptionLabel.frame.height
        let addButtonsHeight: CGFloat = 51
        let miniPlayerHeight: CGFloat = 60
        let detailTextHeight = subtitleLabel.frame.height + 10
        let titleTextHeight = titleLabel.frame.height
        scrollView.contentSize = scrollViewContentSize(fixedHeight: screenWidth + descripHeight + addButtonsHeight + miniPlayerHeight + detailTextHeight + titleTextHeight)
        tableView.contentSize = tableViewContentSize
        tableViewHeight.constant = tableViewContentSize.height
        view.layoutIfNeeded()
    }
    
    final func scrollViewContentSize(fixedHeight: CGFloat) -> CGSize {
        let tableViewSize = tableViewContentSize
        return CGSize (width: tableViewSize.width, height: tableViewSize.height + fixedHeight)
    }
    
    final func descriptionPrefix(from description: String?) -> String? {
        if let description = description, description.count > 140 {
            return String(description.prefix(140))
        }
        return nil
    }
        
    // MARK: UIScrollViewDelegate
    
    final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > nameLabelPosition && !isNavBarShown {
            isNavBarShown = true
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.navigationController?.navigationBar.alpha = 1
            }
        }
        
        if scrollView.contentOffset.y < nameLabelPosition && isNavBarShown {
            isNavBarShown = false
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.navigationController?.navigationBar.alpha = 0
            }
        }
    }
    
    // MARK: - Overridables
    
    open var tableViewContentSize: CGSize {
        return CGSize()
    }
    
    @objc open func handleMoreButtonTap(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.moreButton.isHidden = true
            self?.applyContentSize()
        }
    }
    
    /// Call `super.handleAddButtonTap(_:)` at the end to refresh the table view to reflect add button's
    /// changes. It also shows a checkmark animation.
    @objc open func handleAddButtonTap(_ sender: UIButton) {
        view.addSubview(LottieActivityIndicator.checkmark)
        tableView.reloadData()
    }
    
    @objc open func handlePlaybuttonTap(_ sender: UIButton) {}
    
    @objc open func handleShuffleButtonTap(_ sender: UIButton) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
