//
//  SoundcloudLoginViewController.swift
//  smore
//
//  Created by Sinclair Gurny on 2/10/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SoundcloudLoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    init() {
        super.init(nibName: "SoundcloudLoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.addRoundCorners()
        usernameTextField.addRoundCorners()
        passwordTextField.addRoundCorners()

        
    }


    @IBAction func loginSoundcloudUser(_ sender: UIButton) {
        /* Do login stuff

        */
    }
    
    @IBAction func skip(_ sender: UIButton) {
        
    }
    

}
