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
    private let bag = DisposeBag()
    
    var queue: Variable<[Song]> = Variable([])
    
    private init() {
        queue.asObservable()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] songs in
                self?.currentPosition.value = 0
                Player.shared.play(with: songs.map { $0.playableString })
            })
            .disposed(by: bag)
    }
    
    // MARK: - Instance Variables
    var currentPosition: Variable<Int> = Variable(0)
    
    // MARK: - Computed Vars
    
    var appleMusicIDs: [String] {
        return queue.value.map { $0.playableString }
    }
    
    var currentSong: Song {
        var position = currentPosition.value
        if position < 0 { position = 0 }
        if position >= queue.value.count { position = queue.value.count - 1}
        return queue.value[position]
    }
}


