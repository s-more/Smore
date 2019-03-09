//
//  ArtistLibraryViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher

class ArtistLibraryViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var masterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var index = 0
    let viewModel: ArtistLibraryViewModel
    let activityIndicator = LottieActivityIndicator(animationName: "StrugglingAnt")
    
    init(viewModel: ArtistLibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArtistLibraryViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        warningLabel.isHidden = true
        scrollView.delegate = self
        backgroundImage.kf.setImage(with: viewModel.highResImageURL,
                                    placeholder: UIImage.imageFrom(color: UIColor.black))
        nameLabel.text = viewModel.artist.name
        
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
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
                
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        
        viewModel.prepareData(completion: { [weak self] in
            self?.detailLabel.text = self?.viewModel.details
            self?.activityIndicator.stop()
            self?.applyContentSize(index: 0)
            self?.reloadPagerTabStripView()
            if let vm = self?.viewModel, let vc = vm.viewControllers.first {
                self?.warningLabel.isHidden = !vm.isVCEmpty(vc: vc)
            }
        }, error: { [weak self] err in
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: err.localizedDescription)
            self?.activityIndicator.stop()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = viewModel.artist.name
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.initialButtonBarPosition = buttonBarView.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    private func applyContentSize(index: Int) {
        let innerSize = viewModel.viewControllers[index].innerScrollViewSize()
        let wrapperSize = viewModel.viewControllers[index].wrapperScrollViewSize(immobileSectionHeight: 270)
        containerView.contentSize = innerSize
        scrollView.contentSize = wrapperSize
        masterView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: wrapperSize)
        masterViewHeight.constant = wrapperSize.height
        masterView.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    
    @IBAction func screenEdgeLeftSwiped(_ sender: UIScreenEdgePanGestureRecognizer) {
        if !viewModel.isBarShown {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - XLPagerTabStrip
    
    override func viewControllers(
        for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        return viewModel.viewControllers
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
            navigationController?.setNavigationBarHidden(false, animated: true)
            viewModel.isBarShown = true
        } else if floatingPosition < viewModel.initialButtonBarPosition && viewModel.isBarShown {
            navigationController?.setNavigationBarHidden(true, animated: true)
            viewModel.isBarShown = false
        }
    }
}

