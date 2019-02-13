//
//  SpotifyLoginViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SpotifyLoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    init() {
        super.init(nibName: "SpotifyLoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addRoundCorners()
        usernameTextField.addRoundCorners()
        passwordTextField.addRoundCorners()
        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 0, green: 220/255, blue: 77/255, alpha: 1),
            UIColor(red: 18/255, green: 138/255, blue: 74/255, alpha: 1)
        ]
        loginButton.layer.insertSublayer(CAGradientLayer.gradient(colors: colors,
                                                                  frame: loginButton.bounds), at: 0)
    }
    
    
    @IBAction func loginSpotifyUser(_ sender: UIButton) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text {
            SpotifyAPI.login(username: username, password: password, success: {
                // implement
            }, error: { error in
                // implement
            })
        }
        
        navigationController?.pushViewController(SoundcloudLoginViewController(), animated: true)
    }
    
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(SoundcloudLoginViewController(), animated: true)
    }
    
}
