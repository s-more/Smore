//
//  WelcomeViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nextButton: UIButton!
    
    init() {
        super.init(nibName: "WelcomeViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        
        let colors = [
            UIColor(red: 220/255, green: 148/255, blue: 111/255, alpha: 1),
            UIColor(red: 132/255, green: 87/255, blue: 64/255, alpha: 1)
        ]
        view.layer.insertSublayer(CAGradientLayer.gradient(colors: colors, frame: view.frame), at: 0)
        nextButton.addRoundCorners()
        navigationController?.delegate = self
        
        let activityIndicator = LottieActivityIndicator(animationName: "StrugglingAnt")
        view.addSubview(activityIndicator)
            
        AppleMusicAPI.topCharts(for: [.songs], genre: nil, completion: { data in
            data.songs?.first?.data.forEach { data in
                print(data.attributes.name + " by " + data.attributes.artistName)
            }
            activityIndicator.stop()
        }, error: { error in
            print(error.localizedDescription)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(AppleMusicAuthViewController(), animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
