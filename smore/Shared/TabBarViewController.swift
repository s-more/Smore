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
        browseVC.navigationBar.barTintColor = UIColor.tabBarBackground
        browseVC.navigationBar.tintColor = UIColor.white
        browseVC.navigationBar.barStyle = .black
        browseVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon"), tag: 0)
        
        viewControllers = [browseVC]
        
        tabBar.barTintColor = UIColor.tabBarBackground
        tabBar.unselectedItemTintColor = UIColor.darkGray
        tabBar.tintColor = UIColor.themeColor
    }
}
