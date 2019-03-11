//
//  BrowseTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {
    let viewModel: BrowseViewModel
    
    init() {
        viewModel = BrowseViewModel()
        super.init(nibName: "BrowseTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "S'more"
        tableView.register(UINib(nibName: "SuggestedTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SuggestedTableViewCell.identifier)
        tableView.register(UINib(nibName: "TopChartsTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: TopChartsTableViewCell.identifier)
        tableView.register(UINib(nibName: "BrowseHeader", bundle: Bundle.main),
                           forHeaderFooterViewReuseIdentifier: BrowseHeader.identifier)
        
        let ai = LottieActivityIndicator(animationName: "StrugglingAnt")
        tableView.addSubview(ai)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        viewModel.fetchData(completion: { [weak self] in
            ai.stop()
            self?.tableView.reloadData()
        }, error: { error in
            ai.stop()
            print(error.localizedDescription)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.black
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? SuggestedTableViewCell {
                cell.artists = viewModel.favArtists
                cell.action = { [weak self] artist in
                    let vm = ArtistLibraryViewModel(artist: artist)
                    let vc = ArtistLibraryViewController(viewModel: vm)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TopChartsTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? TopChartsTableViewCell {
                cell.songs = viewModel.topCharts
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headers[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: BrowseHeader.identifier) as? BrowseHeader
        let header = viewModel.headers[section]
        cell?.titleLabel.text = header
        return cell
    }
}
