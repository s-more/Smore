//
//  YoutubeLoginViewController.swift
//  smore
//
//  Created by Nasir Pauldon-Collins on 2/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import GoogleSignIn

class YoutubeLoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginButton: GIDSignInButton!
    @IBOutlet weak var youtubeLabel: UILabel!
    
    init() {
        super.init(nibName: "YoutubeLoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        loginButton.addRoundCorners()
        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            UIColor(red: 255/255, green: 0, blue: 0, alpha: 1)
        ]
        view.addGradient(colors: colors)
//        youtubeLabel.addGradient(colors: colors)
        
        NotificationCenter.default.addObserver(
            forName: .youtubeSignedIn,
            object: nil,
            queue: OperationQueue.main)
        { [weak self] _ in
            FeatureFlags.setYoutubeEnabled(true)
            self?.navigationController?.pushViewController(StartupViewController(), animated: true)
        }
        
        NotificationCenter.default.addObserver(
            forName: .youtubeNotSignedIn,
            object: nil,
            queue: OperationQueue.main)
        { [weak self] _ in
            guard let strongSelf = self else { return }
            UIAlertController.showGenericAlert(
                title: "Youtube Not Signed In",
                subtitle: "Youtube features will not be enabled",
                on: strongSelf)
            { [weak self] _ in
                self?.ensureOneServiceEnabled()
            }
        }
    }
    
    @IBAction func loginYoutubeUser(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func skip(_ sender: UIButton) {
        ensureOneServiceEnabled()
    }
    
    private func ensureOneServiceEnabled() {
        guard FeatureFlags.atLeastOneServiceEnabled else {
            UIAlertController.showGenericAlert(
                title: "Error",
                subtitle: "At least one streaming service must be enabled.",
                on: self)
            return
        }
        navigationController?.pushViewController(StartupViewController(), animated: true)
    }
    
    
}
