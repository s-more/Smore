//
//  SpotifyLoginViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpotifyLoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spotifyLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    let bag = DisposeBag()

    init() {
        super.init(nibName: "SpotifyLoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpotifyRemote.shared.delegate = self
        loginButton.addRoundCorners()
        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 0, green: 220/255, blue: 77/255, alpha: 1),
            UIColor(red: 18/255, green: 138/255, blue: 74/255, alpha: 1)
        ]
        view.addGradient(colors: colors)
//        spotifyLabel.addGradient(colors: colors)
    }
    
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(YoutubeLoginViewController(), animated: true)
    }
    //    OnClick of Auth button, initiate spotify session
    @IBAction func loginSpotifyUser(_ sender: UIButton) {
        SpotifyRemote.shared.spotifyLogin()
    }
}

extension SpotifyLoginViewController: SpotifyRemoteDelegate {
    func remote(spotifyRemote: SpotifyRemote, didAuthenticate status: Bool) {
        if status {
            FeatureFlags.setSpotifyEnabled(true)
            navigationController?.pushViewController(YoutubeLoginViewController(), animated: true)
        }
    }
    
    
}
