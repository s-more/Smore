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
    let bag = DisposeBag()
    
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
        AppleMusicAPI.rx.authorized
            .filter { $0 == true }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.pushViewController(SpotifyLoginViewController(),
                                                                   animated: true)
            })
            .disposed(by: bag)
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(SpotifyLoginViewController(), animated: true)
    }
    
}
