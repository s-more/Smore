//
//  LibraryViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher

class LibraryViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var masterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var followButton: UIButton!
    
    let viewModel: LibraryViewModel
    let activityIndicator = LottieActivityIndicator(animationName: "StrugglingAnt")
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LibraryViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        scrollView.delegate = self
        
        if let image = viewModel.highResImage {
            backgroundImage.image = image
        } else {
            backgroundImage.kf.setImage(with: viewModel.highResImageURL,
                                        placeholder: UIImage.imageFrom(color: UIColor.black))
        }
        
        nameLabel.text = viewModel.titleText
    
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        settings.style.buttonBarBackgroundColor = .black
        settings.style.buttonBarItemBackgroundColor = .black
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name: "AvenirNext-Bold", size: 18.0)!
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarMinimumLineSpacing = 16
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 0
        
        if viewModel.hideFollowButton {
            followButton.isHidden = true
        } else {
            followButton.addSmoreBoder(withWhiteBorder: true)
            if viewModel.disableFollowButton {
                followButton.disable()
            } else {
                followButton.setTitle("  Follow  ", for: .normal)
            }
        }
                
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        
        viewModel.prepareData(completion: { [weak self] in
            self?.detailLabel.text = self?.viewModel.details
            self?.activityIndicator.stop()
            self?.applyContentSize()
            self?.reloadPagerTabStripView()
        }, error: { [weak self] err in
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: err.localizedDescription)
            self?.activityIndicator.stop()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = viewModel.titleText//viewModel.artist.name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            if self?.viewModel.isButtonBarPositionSet ?? false {
                if self?.scrollView.contentOffset.y ?? 0 > self?.viewModel.initialButtonBarPosition ?? 0 {
                    self?.navigationController?.navigationBar.alpha = 1
                } else {
                    self?.navigationController?.navigationBar.alpha = 0
                }
            } else {
                self?.navigationController?.navigationBar.alpha = 0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self ] in
            guard let strongSelf = self else { return }
            if !strongSelf.viewModel.isButtonBarPositionSet {
                strongSelf.viewModel.initialButtonBarPosition = strongSelf.buttonBarView.frame.origin.y
                strongSelf.viewModel.isButtonBarPositionSet = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.alpha = 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func applyContentSize() {
        let fixedHeights = UIScreen.main.bounds.width + 20
        let wrapperSize = viewModel.viewControllers[currentIndex].wrapperScrollViewSize(immobileSectionHeight: fixedHeights)
        scrollView.contentSize = wrapperSize
        masterView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: wrapperSize)
        masterViewHeight.constant = wrapperSize.height
        masterView.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        followButton.setTitle("Following", for: .normal)
        followButton.disable()
        viewModel.followButtonTapped()
    }
    
    // MARK: - XLPagerTabStrip
    
    override func viewControllers(
        for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        return viewModel.viewControllers
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged {
            applyContentSize()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        var headerFrame = buttonBarView.frame
        let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let floatingPosition = scrollView.contentOffset.y + navBarHeight + statusBarHeight
        headerFrame.origin.y = max(viewModel.initialButtonBarPosition, floatingPosition)
        buttonBarView.frame = headerFrame
        
        if floatingPosition > viewModel.initialButtonBarPosition && !viewModel.isBarShown {
            UIView.animate(
                withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                animations: { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 1
            }, completion: nil)
            viewModel.isBarShown = true
        } else if floatingPosition < viewModel.initialButtonBarPosition && viewModel.isBarShown {
            UIView.animate(
                withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                animations: { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 0
                }, completion: nil)
            viewModel.isBarShown = false
        }
    }
}

