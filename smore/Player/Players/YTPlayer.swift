//
//  YTPlayer.swift
//  smore
//
//  Created by Khalil Fleming on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class YTPlayer: NSObject, PlayerProtocol{
    var currentPlaybackTime: String = ""
    var remainingPlaybackTime: String? = nil
    var nowPlayingItemPlaybackTime: TimeInterval? = 0
    var currentPlaybackPercentage: Float = 0
    
    var state: PlayerState = .notPlaying
    var isShuffling: Bool = false
    var subQueue: [Song]
    var positionInSubQueue: Int
    
    var shuffleModeTintColor: UIColor {
        return isShuffling ? UIColor.themeColor : UIColor.white
    }
    
    var repeatModeTintColor: UIColor {
        return UIColor.white
    }
    
    override init() {
        subQueue = []
        positionInSubQueue = 0
        super.init()
    }
    
    func play(with songs: [Song]) {
        subQueue = songs
        if positionInSubQueue < subQueue.count - 1 {
            YoutubeRemote.shared.play(videoID: subQueue[positionInSubQueue].playableString)
            
        } else {
            NotificationCenter.default.post(name: .skipToNextQueue, object: nil)
        }
    }
    
    func skipToNext() {
        if positionInSubQueue < subQueue.count - 1 {
            positionInSubQueue += 1
            YoutubeRemote.shared.play(videoID: subQueue[positionInSubQueue].playableString)
            
        } else {
            NotificationCenter.default.post(name: .skipToNextQueue, object: Player.shared)
        }
    }
    
    func skipToPrev() {
        if positionInSubQueue > 0 {
            positionInSubQueue -= 1
            YoutubeRemote.shared.play(videoID: subQueue[positionInSubQueue].playableString)
            
        } else {
            // post notification to skip to next queue
            NotificationCenter.default.post(name: .skipToPreviousQueue, object: nil)
        }
    }
    
    func skipToCurrentPosition() {
        // TODO
    }
    
    func playOrPause() {
        switch state {
        case .playing:
            state = .paused
            YoutubeRemote.shared.pause()
        case .paused, .notPlaying:
            state = .playing
            YoutubeRemote.shared.resume()
        }
    }
    
    func stop() {
        YoutubeRemote.shared.stop()
    }
    
    func toggleRepeatMode() {
    }
    
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        if !isShuffling {
            isShuffling = true
            YoutubeRemote.shared.setShuffle(state: true)
        } else {
            isShuffling = false
            YoutubeRemote.shared.setShuffle(state: false)
        }
    }
    
    func setCurrentPlaybackTime(with time: TimeInterval) {
    }
    

}
