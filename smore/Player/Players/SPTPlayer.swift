//
//  SPTPlayer.swift
//  smore
//
//  Created by Jing Wei Li on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class SPTPlayer: NSObject, PlayerProtocol {
    
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
        SpotifyRemote.shared.appRemote.playerAPI?.setRepeatMode(repeatMode, callback: nil)
        SpotifyRemote.shared.appRemote.playerAPI?.setShuffle(isShuffling, callback: nil)
        subQueue = []
        positionInSubQueue = 0
        super.init()
    }
    
    func play(with songs: [Song]) {
        subQueue = songs
        if positionInSubQueue < subQueue.count - 1 {
            SpotifyRemote.shared.appRemote.playerAPI?.play(subQueue[positionInSubQueue].playableString, callback: nil)
        } else {
            // TODO: post notification to skip to next queue
            NotificationCenter.default.post(name: .skipToNextQueue, object: nil)
        }
        
    }
    
    func skipToNext() {
        //SpotifyRemote.shared.appRemote.playerAPI?.skip(toNext: nil)
        if positionInSubQueue < subQueue.count - 1 {
            positionInSubQueue += 1
            SpotifyRemote.shared.appRemote.playerAPI?.play(subQueue[positionInSubQueue].playableString, callback: nil)
        } else {
           NotificationCenter.default.post(name: .skipToNextQueue, object: Player.shared)
        }
    }
    
    func skipToPrev() {
        if positionInSubQueue > 0 {
            positionInSubQueue -= 1
            SpotifyRemote.shared.appRemote.playerAPI?.play(subQueue[positionInSubQueue].playableString, callback: nil)
        } else {
            // post notification to skip to next queue
            NotificationCenter.default.post(name: .skipToPreviousQueue, object: nil)
        }
    }
    
    func skipToCurrentPosition() {
        // todo
    }
    
    func playOrPause() {
        switch state {
        case .playing:
            state = .paused
            SpotifyRemote.shared.appRemote.playerAPI?.pause(nil)
        case .paused, .notPlaying:
            state = .playing
            SpotifyRemote.shared.appRemote.playerAPI?.resume(nil)
        }
    }
    
    func stop() {
        SpotifyRemote.shared.appRemote.playerAPI?.pause(nil)
    }
    
    func toggleRepeatMode() {
        if repeatMode == .off {
            repeatMode = .track
            SpotifyRemote.shared.appRemote.playerAPI?.setRepeatMode(.track, callback: nil)
        } else if repeatMode == .track {
            repeatMode = .off
            SpotifyRemote.shared.appRemote.playerAPI?.setRepeatMode(.off, callback: nil)
        }
    }
    
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        if !isShuffling {
            isShuffling = true
            SpotifyRemote.shared.appRemote.playerAPI?.setShuffle(true) { _, err in
                if let err = err {
                    error(err)
                } else {
                    completion()
                }
            }
        } else {
            isShuffling = false
            SpotifyRemote.shared.appRemote.playerAPI?.setShuffle(false) { _, err in
                if let err = err {
                    error(err)
                } else {
                    completion()
                }
            }
        }
    }
    
    func setCurrentPlaybackTime(with time: TimeInterval) {
        SpotifyRemote.shared.appRemote.playerAPI?.seek(toPosition: Int(time * 1000), callback: nil)
    }
}

extension SPTPlayer: SPTAppRemotePlayerStateDelegate {
    /// 🚗PlayerState: context  playbackPos: 0 playbackSpd: 0.0 isPaused: true🚗
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        
        // completed plakback of a single song
//        print("🚗 playerState: contextTitle: \(playerState.contextTitle) playbackposition: \(playerState.playbackPosition):  paused: \(playerState.isPaused) spd: \(playerState.playbackSpeed)")
        if playerState.contextTitle == "" && playerState.playbackPosition == 0 && playerState.isPaused {
            print("🚗 Completed playback of current song 🚗")
            if positionInSubQueue < subQueue.count - 1 {
                positionInSubQueue += 1
                SpotifyRemote.shared.appRemote.playerAPI?.play(subQueue[positionInSubQueue].playableString, callback: nil)
                MusicQueue.shared.currentPosition.value += 1
            } else {
                // TODO: post notification to skip to next queue
                NotificationCenter.default.post(name: .skipToNextQueue, object: nil)
            }
        }
    }
}
