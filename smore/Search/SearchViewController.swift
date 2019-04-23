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
    let activityIndicator = LottieActivityIndicator.smoreExplosion
    
    var dataSource: Variable<SearchDataSource> = Variable(APMSearchDataSource())
    var searchHintsDataSource: Variable<SearchHintDataSource> = Variable(SearchHintDataSource(searchHints: []))
    
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
        searchBar.delegate = self
        tableView.dataSource = dataSource.value
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        navigationItem.title = "Search"
        viewModel.initialSearchBarPosition = searchBar.frame.origin.y
        
        tableView.register(UINib(nibName: "GenericTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: GenericTableViewCell.identifier)
        tableView.register(UINib(nibName: "SuggestedTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SuggestedTableViewCell.identifier)
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.register(UINib(nibName: "BrowseHeader", bundle: Bundle.main),
                           forHeaderFooterViewReuseIdentifier: BrowseHeader.identifier)
        
        serviceToggle.removeAllSegments()
        for (index, segment) in viewModel.searchDataSources.enumerated() {
            serviceToggle.insertSegment(withTitle: segment.name, at: index, animated: false)
        }
        serviceToggle.selectedSegmentIndex = 0
        
        dataSource.asObservable()
            .subscribe(onNext: { [weak self] ds in
                self?.applyContentSize(from: ds)
                self?.tableView.dataSource = ds
                self?.tableView.reloadData()
                if let artistsCell = self?.tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? SuggestedTableViewCell {
                    artistsCell.action = { artist in
                        let vm = ArtistLibraryViewModel(artist: artist)
                        let vc = LibraryViewController(viewModel: vm)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
            .disposed(by: bag)
        
        searchHintsDataSource.asObservable()
            .subscribe(onNext: { [weak self] ds in
                self?.tableView.dataSource = ds
                self?.tableView.reloadData()
            })
            .disposed(by: bag)

        serviceToggle.rx.selectedSegmentIndex
            .filter { $0 >= 0 }
            .flatMap { [weak self] index -> Observable<SearchDataSource> in
                guard let strongSelf = self else { return Observable.empty() }
                return Observable.just(strongSelf.viewModel.searchDataSources[index])
            }
            .bind(to: dataSource)
            .disposed(by: bag)
        
        let dataSourceFunction = dataSource.value.searchHintDataSource(from:)
        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .flatMapLatest { [weak self] term -> Observable<([String]?, Error?)> in
                guard let ds = self?.dataSource else { return Observable.empty() }
                return ds.value.searchHints(from: term)
            }
            .map { $0.0 ?? [] }
            .flatMapLatest { Observable.just(dataSourceFunction($0)) }
            .bind(to: searchHintsDataSource)
            .disposed(by: bag)
        
        searchBar.rx.text.orEmpty
            .filter { $0.count == 0 }
            .flatMapLatest { _ in Observable.just(SearchHintDataSource(searchHints: [])) }
            .bind(to: searchHintsDataSource)
            .disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if scrollView.contentOffset.y > viewModel.initialSearchBarPosition {
            navigationController?.navigationBar.alpha = 1
        } else {
            navigationController?.navigationBar.alpha = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func applyContentSize(from dataSource: SearchDataSource) {
        scrollView.contentSize = SearchViewModel.scrollViewContentSize(from: dataSource)
        tableView.contentSize = SearchViewModel.tableViewContentSize(from: dataSource)
        tableViewHeight.constant = SearchViewModel.tableViewContentSize(from: dataSource).height
        view.layoutIfNeeded()
    }
    
    func search(with text: String) {
        searchBar.resignFirstResponder()
        searchBar.text = text
        view.addSubview(activityIndicator)
        navigationController?.navigationBar.alpha = 0.001 // fixed a weird error where nav bar disappears
        viewModel.search(with: text, dataSource: dataSource.value, completion: { [weak self] ds in
            self?.dataSource.value = ds // triggers onNext(:_) with value being set
            self?.activityIndicator.stop()
        }, error: { [weak self] error in
            self?.activityIndicator.stop()
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: error.localizedDescription)
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            search(with: text)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let searchHints = (tableView.dataSource as? SearchHintDataSource)?.searchHints {
            search(with: searchHints[indexPath.row])
        } else if let searchDataSource = tableView.dataSource as? SearchDataSource {
            switch indexPath.section {
            case 1:
                let vc = AlbumContentViewController(album: searchDataSource.albums[indexPath.row])
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vm = PlaylistContentViewModel(playlist: searchDataSource.playlists[indexPath.row])
                let vc = PlaylistContentViewController(viewModel: vm)
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                if searchDataSource.songs[indexPath.row].streamingService == StreamingService.spotify {
                    Player.shared.stop()
                    SpotifyRemote.shared.appRemote.playerAPI?.play(searchDataSource.songs[indexPath.row].playableString, callback: SpotifyRemote.shared.defaultCallback)
                } else if searchDataSource.songs[indexPath.row].streamingService == StreamingService.youtube {
                    Player.shared.stop()
                    MusicQueue.shared.queue.value = Array([searchDataSource.songs[indexPath.row]])
                    present(YoutubePlayerController(song: searchDataSource.songs[indexPath.row]), animated: true)
                    YoutubeRemote.shared.play(videoID: searchDataSource.songs[indexPath.row].playableString)
                } else {
                    SpotifyRemote.shared.appRemote.playerAPI?.pause(SpotifyRemote.shared.defaultCallback)
                    MiniPlayer.shared.configure(with: searchDataSource.songs[indexPath.row])
                    MusicQueue.shared.queue.value = Array([searchDataSource.songs[indexPath.row]])
                }
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.dataSource is SearchHintDataSource ? 0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.dataSource is SearchHintDataSource { return 50 }
        if indexPath.section == 0 {
            if dataSource.value.artists.count > 0 { return 210 }
            return 0
        }
        return SearchTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.dataSource is SearchHintDataSource { return nil }
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
            UIView.animate(
                withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 1
                })
        }
        
        if floatingPosition <= viewModel.initialSearchBarPosition && viewModel.shouldNavBarBeShown {
            viewModel.shouldNavBarBeShown = false
            UIView.animate(
                withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                    self?.navigationController?.navigationBar.alpha = 0
                })
        }
    }
}
