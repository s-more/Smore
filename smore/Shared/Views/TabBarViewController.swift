//
//  TabBarViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let browseVC = UINavigationController(rootViewController: BrowseTableViewController())
        configureNavBar(on: browseVC)
        browseVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon"), tag: 0)
        
        let searchVM = SearchViewModel(dataSources: [APMSearchDataSource(), AllSearchDataSource()])
        let searchVC = UINavigationController(rootViewController: SearchViewController(viewModel: searchVM))
        searchVC.navigationBar.tintColor = UIColor.white
        searchVC.navigationBar.shadowImage = UIImage()
        searchVC.navigationBar.barStyle = .black
        searchVC.navigationBar.isTranslucent = true
        searchVC.navigationBar.backgroundColor = UIColor.black
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchIcon"), tag: 1)
        
        viewControllers = [browseVC, searchVC]
        
        tabBar.barTintColor = UIColor.tabBarBackground
        tabBar.unselectedItemTintColor = UIColor.darkGray
        tabBar.tintColor = UIColor.themeColor
        
        MiniPlayer.tabBarHeight = tabBar.frame.height
        view.addSubview(MiniPlayer.shared)
        MiniPlayer.shared.isHidden = true
        MiniPlayer.shared.swipeAction = { [weak self] in
            self?.present(PlayerViewController.current, animated: true)
        }
    }
    
    func configureNavBar(on vc: UINavigationController) {
        vc.navigationBar.barTintColor = UIColor.black
        vc.navigationBar.tintColor = UIColor.white
        vc.navigationBar.barStyle = .black
    }
}
