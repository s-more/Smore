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
    var repeatMode: SPTAppRemotePlaybackOptionsRepeatMode = .off
    var subQueue: [Song]
    var positionInSubQueue: Int
    
    var shuffleModeTintColor: UIColor {
        return isShuffling ? UIColor.themeColor : UIColor.white
    }
    
    var repeatModeTintColor: UIColor {
        return repeatMode == .off ? UIColor.white : UIColor.themeColor
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
            // TODO: post notification to skip to next queue
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
        //a
    }
    
    func playOrPause() {
        switch state {
        case .playing:
            state = .paused
            //YoutubeRemote.shared.appRemote.playerAPI?.pause(nil)
        case .paused, .notPlaying:
            state = .playing
            //YoutubeRemote.shared.appRemote.playerAPI?.resume(nil)
        }
    }
    
    func stop() {
        //a
    }
    
    func toggleRepeatMode() {
        //a
    }
    
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        //a
    }
    
    func setCurrentPlaybackTime(with time: TimeInterval) {
        //a
    }
    

}
