//
//  MusicQueue.swift
//  smore
//
//  Created by Jing Wei Li on 3/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import RxSwift

class MusicQueue {
    static let shared = MusicQueue()
    let bag = DisposeBag()
    
    var queue: Variable<[Song]> = Variable([])
    
    init() {
        queue.asObservable()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] songs in
                self?.currentPosition = 0
                Player.shared.play(with: songs.map { $0.playableString })
            })
            .disposed(by: bag)
    }
    
    // MARK: - Instance Variables
    var currentPosition: Int = 0
    
    // MARK: - Computed Vars
    
    var appleMusicIDs: [String] {
        return queue.value.map { $0.playableString }
    }
    
}


