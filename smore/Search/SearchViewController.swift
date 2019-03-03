//
//  SearchViewController.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var serviceToggle: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let viewModel: SearchViewModel
    let bag = DisposeBag()
    
    var dataSource: UITableViewDataSource = APMSearchDataSource() {
        didSet {
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        viewModel.initialSearchBarPosition = searchBar.frame.origin.y
        
//        tableView.register(UINib(nibName: "GenericTableViewCell", bundle: Bundle.main),
//                           forCellReuseIdentifier: GenericTableViewCell.identifier)
        tableView.register(UINib(nibName: "SuggestedTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SuggestedTableViewCell.identifier)
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.register(UINib(nibName: "BrowseHeader", bundle: Bundle.main),
                           forHeaderFooterViewReuseIdentifier: BrowseHeader.identifier)
        
        let titleLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabelView.backgroundColor = .clear
        titleLabelView.textAlignment = .center
        titleLabelView.textColor = UIColor.white
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabelView.text = ""
        self.navigationItem.titleView = titleLabelView
        
        serviceToggle.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let strongSelf = self else { return }
                strongSelf.dataSource = strongSelf.viewModel.searchDataSources[index]
            })
            .disposed(by: bag)
        
        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .flatMapLatest { AppleMusicAPI.rx.searchResults(from: $0) }
            .subscribe(onNext: { [weak self] response in
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = response.0, let dataSource = (self?.dataSource) as? SearchDataSource {
                        let ds = SearchViewModel.populateSearchDataSource(with: dataSource, data: data)
                        DispatchQueue.main.async {
                            self?.scrollView.contentSize = SearchViewModel.scrollViewContentSize(from: ds)
                            self?.tableView.contentSize = SearchViewModel.tableViewContentSize(from: ds)
                            self?.tableViewHeight.constant = SearchViewModel.tableViewContentSize(from: ds).height
                            self?.view.layoutIfNeeded()
                            self?.dataSource = ds
                        }
                    }
                }
            })
            .disposed(by: bag)
        
        /*
        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .flatMapLatest { AppleMusicAPI.rx.searchHints(from: $0) }
            .subscribe(onNext: { [weak self] text in
                if let hints = text.0, let dataSource = self?.viewModel.searchHintsDataSource {
                    dataSource.searchHints = hints
                    self?.dataSource = dataSource
                }
            })
            .disposed(by: bag)
        */
        
        /*
        searchBar.rx.text.orEmpty
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                if let dataSource = self?.viewModel.searchHintsDataSource {
                    dataSource.searchHints = []
                    self?.dataSource = dataSource
                }
            })
            .disposed(by: bag)
        */
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: bag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let dataSource = dataSource as? SearchDataSource, dataSource.artists.count > 0 {
                return 210
            }
            return 0
        }
        return SearchTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: BrowseHeader.identifier) as? BrowseHeader
        let header = viewModel.sectionHeaders[section]
        cell?.titleLabel.text = header
        return cell
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var headerFrame = searchBar.frame
        let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let floatingPosition = scrollView.contentOffset.y + navBarHeight + statusBarHeight
        headerFrame.origin.y = max(viewModel.initialSearchBarPosition, floatingPosition)
        searchBar.frame = headerFrame
        
        if floatingPosition > viewModel.initialSearchBarPosition && !viewModel.shouldNavBarBeShown {
            viewModel.shouldNavBarBeShown = true
            searchBar.barTintColor = UIColor.tabBarBackground
            if let labelView = navigationItem.titleView as? UILabel {
                labelView.layer.add(SlidingViewTransition.up, forKey: "NavSlideUp")
                labelView.text = "Search"
            }
        }
        
        if floatingPosition <= viewModel.initialSearchBarPosition && viewModel.shouldNavBarBeShown {
            viewModel.shouldNavBarBeShown = false
            navigationItem.title = ""
            navigationController?.navigationBar.backgroundColor = UIColor.black
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            
            if let labelView = navigationItem.titleView as? UILabel {
                labelView.layer.add(SlidingViewTransition.down, forKey: "NavSlideDown")
                labelView.text = ""
            }
        }
    }
}
