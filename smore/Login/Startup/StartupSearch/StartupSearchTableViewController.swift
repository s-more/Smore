//
//  StartupSearchTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/18/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class StartupSearchTableViewController: UITableViewController {
    let bag = DisposeBag()
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 180, height: 20))
    var artists: [APMArtist] = []
    var completion: ((APMArtist) -> Void)?
    
    init() {
        super.init(nibName: "StartupSearchTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search for your favorite artists!"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        tableView.register(UINib(nibName: "StartupSearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: StartupSearchTableViewCell.identifier)
        
        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .flatMapLatest { AppleMusicAPI.rx.searchResults(from: $0) }
            .subscribe(onNext: { [weak self] response in
                if let results = response.0 {
                    self?.artists = APMArtist.convert(results: results)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else if let error = response.1 {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: bag)
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StartupSearchTableViewCell.identifier,
                                                 for: indexPath)
        if let cell = cell as? StartupSearchTableViewCell {
            cell.startupCellImageView?.kf.setImage(with: artists[indexPath.row].imageLink,
                                        placeholder: UIImage(named: "artistPlaceholder"))
            cell.startupCellMasterLabel?.text = artists[indexPath.row].name
            cell.startupCellDetailLabel?.text = artists[indexPath.row].genre
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        completion?(artists[indexPath.row])
    }
    
}

extension StartupSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
