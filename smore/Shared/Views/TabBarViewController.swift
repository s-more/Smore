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
        
        var dataSources: [SearchDataSource] = []
        if FeatureFlags.appleMusicEnabled { dataSources.append(APMSearchDataSource()) }
        if FeatureFlags.spotifyEnabled { dataSources.append(SPTSearchDataSource()) }
        if FeatureFlags.youtubeEnabled { dataSources.append(YTSearchDataSource()) }
        let searchVM = SearchViewModel(dataSources: dataSources)
        let searchVC = UINavigationController(rootViewController: SearchViewController(viewModel: searchVM))
        searchVC.navigationBar.tintColor = UIColor.white
        searchVC.navigationBar.shadowImage = UIImage()
        searchVC.navigationBar.barStyle = .black
        searchVC.navigationBar.isTranslucent = true
        searchVC.navigationBar.backgroundColor = UIColor.black
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchIcon"), tag: 2)
        
        let localLibraryVC = LibraryViewController(viewModel: LocalLibraryViewModel())
        let localLibraryNavController = UINavigationController(rootViewController: localLibraryVC)
        configureNavBar(on: localLibraryNavController)
        localLibraryNavController.navigationBar.setBackgroundImage(nil, for: .default)
        localLibraryNavController.navigationBar.backgroundColor = UIColor.black
        localLibraryNavController.tabBarItem = UITabBarItem(
            title: "Library", image: UIImage(named: "LibraryIcon"), tag: 1)
        
        let settingsVC = SettingsTableViewController()
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        configureNavBar(on: settingsNavController)
        settingsNavController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "SettingsIcon"), tag: 3)
        
        viewControllers = [browseVC, localLibraryNavController, searchVC, settingsNavController]
        
        tabBar.barTintColor = UIColor.tabBarBackground
        tabBar.unselectedItemTintColor = UIColor.darkGray
        tabBar.tintColor = UIColor.themeColor
        
        MiniPlayer.tabBarHeight = tabBar.frame.height
        view.addSubview(MiniPlayer.shared)
        MiniPlayer.shared.isHidden = true
    }
    
    func configureNavBar(on vc: UINavigationController) {
        vc.navigationBar.barTintColor = UIColor.black
        vc.navigationBar.tintColor = UIColor.white
        vc.navigationBar.barStyle = .black
    }
}
