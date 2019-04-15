//
//  PlayerProtocol.swift
//  smore
//
//  Created by Jing Wei Li on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

protocol PlayerProtocol: NSObjectProtocol {
    var currentPlaybackTime: String { get }
    var remainingPlaybackTime: String? { get }
    var nowPlayingItemPlaybackTime: TimeInterval? { get }
    var currentPlaybackPercentage: Float { get }
    var shuffleModeTintColor: UIColor { get }
    var repeatModeTintColor: UIColor { get }
    var state: PlayerState { get set }
    var subQueue: [Song] { get set }
    
    func play(with songs: [Song])
    func skipToNext()
    func skipToPrev()
    func skipToCurrentPosition()
    func playOrPause()
    func stop()
    func toggleRepeatMode()
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void)
    func setCurrentPlaybackTime(with time: TimeInterval)
}
