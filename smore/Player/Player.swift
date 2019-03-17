//
//  Player.swift
//  smore
//
//  Created by Jing Wei Li on 3/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import MediaPlayer

class Player {
    static let shared = Player()

    let player: MPMusicPlayerApplicationController
    var state: PlayerState
    
    init() {
        player = MPMusicPlayerApplicationController.applicationQueuePlayer
        player.prepareToPlay()
        player.beginGeneratingPlaybackNotifications()
        state = .notPlaying
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main)
        { [weak self] _ in
            for (index, song) in MusicQueue.shared.queue.value.enumerated() {
                if let songName = self?.player.nowPlayingItem?.title, song.name == songName {
                    MiniPlayer.shared.configure(with: song)
                    MusicQueue.shared.currentPosition = index
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main)
        { [weak self] _ in
            if let state = self?.player.playbackState, state == .stopped {
                MiniPlayer.shared.reset()
            }
        }
    }
    
    func play(with appleMusicIDs: [String]) {
        player.setQueue(with: appleMusicIDs)
        player.play()
        state = .playing
    }
    
    func playOrPause() {
        switch state {
        case .playing:
            state = .paused
            player.pause()
        case .paused, .notPlaying:
            state = .playing
            player.play()
        }
    }
    
    func stop() {
        player.stop()
        state = .notPlaying
    }
    
    
}
