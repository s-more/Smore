//
//  ViewController.swift
//  smore
//
//  Created by Jing Wei Li on 1/27/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let appleMusicAuth = AppleMusicAPI.rx.authorized.share()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleMusicAuth
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                let needsSubscription  = AppleMusicAPI.rx.needsSubscription.share()
                needsSubscription
                    .filter { $0 != nil }
                    .subscribe(onNext: { strongSelf.present($0!, animated: true) })
                    .disposed(by: strongSelf.bag)
            }).disposed(by: bag)
 
        let ai = LottieActivityIndicator(animationName: "StrugglingAnt")
        view.addSubview(ai)
        AppleMusicAPI.searchCatalog(with: "Sabrina Carpenter", success: { result in
            result.songs?.data.forEach { data in
                print(data.attributes.name + " in album " + data.attributes.albumName)
            }
            ai.stop()
        }, error: { error in
            print(error.localizedDescription)
        })
        
    }


}

