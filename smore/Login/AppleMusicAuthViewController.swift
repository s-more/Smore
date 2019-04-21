//
//  AppleMusicAuthViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift

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
        AppleMusicAPI.authrozeAndRequestUserToken(success: { [weak self] in
            self?.navigationController?.pushViewController(SpotifyLoginViewController(), animated: true)
        }, error: { [weak self] error in
            guard let strongSelf = self else { return }
            UIAlertController.showGenericAlert(
                title: "Error",
                subtitle: error.localizedDescription,
                on: strongSelf,
                completion:
            { _ in
                strongSelf.navigationController?
                    .pushViewController(SpotifyLoginViewController(), animated: true)
            })
        })
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(SpotifyLoginViewController(), animated: true)
    }
    
}
