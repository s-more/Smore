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
        backgroundImage.kf.setImage(with: viewModel.highResImageURL,
                                    placeholder: UIImage.imageFrom(color: UIColor.black))
        nameLabel.text = viewModel.artist.name
        
        let statusBarHeight: CGFloat = 20
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let contentInsetY = statusBarHeight + navBarHeight
        scrollView.contentInset = UIEdgeInsets(top: -contentInsetY, left: 0, bottom: 0, right: 0)
        
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    // MARK: - Helpers
    
    private func applyContentSize(index: Int) {
        let innerSize = viewModel.viewControllers[index].innerScrollViewSize()
        let wrapperSize = viewModel.viewControllers[index].wrapperScrollViewSize(immobileSectionHeight: 270)
        containerView.contentSize = innerSize
        scrollView.contentSize = wrapperSize
        masterView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: wrapperSize)
        masterViewHeight.constant = wrapperSize.height
        masterView.layoutIfNeeded()
    }
    
    
    // MARK: - XLPagerTabStrip
    
    override func viewControllers(
        for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        return viewModel.viewControllers
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        
    }
}

