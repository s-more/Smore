//
//  AppleMusicAuthViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class AppleMusicAuthViewController: UIViewController {
    @IBOutlet weak var authorizeButton: UIButton!
    
    init() {
        super.init(nibName: "AppleMusicAuthViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 234/255, green: 101/255, blue: 154/255, alpha: 1),
            UIColor(red: 126/255, green: 58/255, blue: 136/255, alpha: 1)
        ]
        view.layer.insertSublayer(CAGradientLayer.gradient(colors: colors, frame: view.frame), at: 0)
        
        authorizeButton.addRoundCorners()
    }
    
    @IBAction func authorizeButtonTapped(_ sender: UIButton) {
        AppleMusicAPI.requestAuthorization { [weak self] success, _ in
            DispatchQueue.main.async {
                if success {
                    guard let strongSelf = self else { return }
                    strongSelf.navigationController?.pushViewController(SpotifyLoginViewController(), animated: true)
                }
            }
        }
    }
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(YoutubeLoginViewController(), animated: true)
    }
    
}
