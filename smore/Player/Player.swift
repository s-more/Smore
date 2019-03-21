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
    
    private init() {
        player = MPMusicPlayerApplicationController.applicationQueuePlayer
        player.prepareToPlay()
        player.beginGeneratingPlaybackNotifications()
        state = .notPlaying
        player.repeatMode = .none
        player.shuffleMode = .off
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main)
        { [weak self] _ in
            for (index, song) in MusicQueue.shared.queue.value.enumerated() {
                if let songName = self?.player.nowPlayingItem?.title, song.name == songName {
                    MiniPlayer.shared.configure(with: song)
                    MusicQueue.shared.currentPosition.value = index
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
            MiniPlayer.shared.updatePlayIconImage()
        }
    }
    
    // MARK: - Computed Vars
    
    var currentPlaybackTime: String {
        let currentTime = player.currentPlaybackTime
        return Utilities.timeIntervalToReg(from: currentTime)
    }
    
    var remainingPlaybackTime: String? {
        if let totalTime = player.nowPlayingItem?.playbackDuration {
            let remainingTime = totalTime - player.currentPlaybackTime
            return Utilities.timeIntervalToReg(from: remainingTime)
        }
        return nil
    }
    
    var nowPlayingItemPlaybackTime: TimeInterval? {
        return player.nowPlayingItem?.playbackDuration
    }
    
    var currentPlaybackPercentage: Float {
        if let totalTime = player.nowPlayingItem?.playbackDuration {
            return Float(player.currentPlaybackTime / totalTime)
        }
        return 0
    }
    
    var shuffleModeTintColor: UIColor {
        return player.shuffleMode == .songs ? UIColor.themeColor : UIColor.white
    }
    
    var repeatModeTintColor: UIColor {
        return player.repeatMode == .one ? UIColor.themeColor : UIColor.white
    }
    
    // MARK: - Methods
    
    func play(with appleMusicIDs: [String]) {
        player.setQueue(with: appleMusicIDs)
        player.play()
        state = .playing
    }
    
    func skipToNext() {
        player.skipToNextItem()
        MusicQueue.shared.currentPosition.value += 1
        if MusicQueue.shared.currentPosition.value >= MusicQueue.shared.queue.value.count {
            MusicQueue.shared.currentPosition.value = MusicQueue.shared.queue.value.count - 1
        }
    }
    
    func skipToPrev() {
        player.skipToPreviousItem()
        MusicQueue.shared.currentPosition.value -= 1
        if MusicQueue.shared.currentPosition.value < 0 {
            MusicQueue.shared.currentPosition.value = 0
        }
    }
    
    func skipToCurrentPosition() {
        var index = player.indexOfNowPlayingItem
        while index < MusicQueue.shared.currentPosition.value {
            player.skipToNextItem()
            index += 1
        }
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
    
    func toggleRepeatMode() {
        if player.repeatMode == .none || player.repeatMode == .default {
            player.repeatMode = .one
        } else if player.repeatMode == .one {
            player.repeatMode = .none
        }
    }
    
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        if player.shuffleMode == .off || player.shuffleMode == .default {
            player.shuffleMode = .songs
        } else if player.shuffleMode == .songs {
            player.shuffleMode = .off
        }
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.player.perform(queueTransaction: { queue in
                // reorder the current [Song] queue to match the queue
                let musicQueue = MusicQueue.shared
                var slicedArray =
                    Array(musicQueue.queue.value[musicQueue.currentPosition.value ..< musicQueue.queue.value.count])
                slicedArray.sort { first, next in
                    guard
                        let firstItem = queue.items.first(where: { item -> Bool in
                            return (item.title ?? "") == first.name
                        }),
                        let firstIndex = queue.items.firstIndex(of: firstItem),
                        let nextItem = queue.items.first(where: { item -> Bool in
                            return (item.title ?? "") == next.name
                        }),
                        let nextIndex = queue.items.firstIndex(of: nextItem) else { return false }
                    return firstIndex < nextIndex
                }
                musicQueue.queue.value = slicedArray
                completion()
            }, completionHandler: { _ , err in
                if let err = err { error(err) }
            })
        }
    }
}
