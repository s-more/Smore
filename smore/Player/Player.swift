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

    private var currentPlayer: PlayerProtocol
    let appleMusicPlayer: APMPlayer
    let spotifyPlayer: SPTPlayer
    let youtubePlayer: YTPlayer
    
    private var subQueues: [[Song]]
    
    private var currentPositionIncremented = false
    
    private init() {
        appleMusicPlayer = APMPlayer()
        spotifyPlayer = SPTPlayer()
        youtubePlayer = YTPlayer()
        currentPlayer = appleMusicPlayer
        subQueues = []
        SpotifyRemote.shared.delegate = self
        
        NotificationCenter.default.addObserver(
            forName: .skipToNextQueue,
            object: nil,
            queue: OperationQueue.main)
        { [weak self] _ in
            guard let strongSelf = self else { return }
            if !strongSelf.subQueues.isEmpty {
                if strongSelf.subQueues.first?.first?.streamingService ?? .none != .spotify { MusicQueue.shared.currentPosition.value += 1
                }
                strongSelf.currentPositionIncremented = true
                strongSelf.playSongsWithCorrectPlayer(using: strongSelf.subQueues.removeFirst())
                
            } else {
                MiniPlayer.shared.reset()
            }
        }
    }
    
    // MARK: - Computed Vars
    
    var state: PlayerState {
        set {
           currentPlayer.state = state
        } get {
            return currentPlayer.state
        }
    }
    
    var currentPlaybackTime: String {
        return currentPlayer.currentPlaybackTime
    }
    
    var remainingPlaybackTime: String? {
        return currentPlayer.remainingPlaybackTime
    }
    
    var nowPlayingItemPlaybackTime: TimeInterval? {
        return currentPlayer.nowPlayingItemPlaybackTime
    }
    
    var currentPlaybackPercentage: Float {
        return currentPlayer.currentPlaybackPercentage
    }
    
    var shuffleModeTintColor: UIColor {
        return currentPlayer.shuffleModeTintColor
    }
    
    var repeatModeTintColor: UIColor {
        return currentPlayer.repeatModeTintColor
    }
    
    // MARK: - Methods
    
    /// Divide up the queue to a double array where each child array contains songs of the same kind
    /// ```
    /// [APMSong, APMSong, SPTSong, SPTSong, APMSong]
    ///                      |
    ///                      |
    ///                     \/
    /// [APMSong, APMSong], [SPTSong, SPTSong], [APMSong]
    /// ```
    /// Feed each sub-queue to the correct player. If the playback of the queue ends we check if there
    /// exists a subsequent queue. If so we tell the player to play that queue with the right player
    /// as well
    func play(with songs: [Song]) {
        subQueues.removeAll()
        var temp: [Song] = []
        for (index, song) in songs.enumerated() {
            if index == 0 {
                temp.append(song)
                if (index == songs.count - 1) { subQueues.append(temp) }
                continue
            }
            
            if (song.streamingService != songs[index - 1].streamingService) {
                subQueues.append(temp)
                temp = [song]
            } else {
                temp.append(song)
            }
            
            if(index == songs.count - 1) { subQueues.append(temp) }
        }
        
        if !subQueues.isEmpty {
            playSongsWithCorrectPlayer(using: subQueues.removeFirst())
        }
        
    }
    
    func playSongsWithCorrectPlayer(using queue: [Song]) {
        if let firstSong = queue.first {
            switch firstSong.streamingService {
            case .appleMusic:
                currentPlayer = appleMusicPlayer
                currentPlayer.play(with: queue)
            case .spotify:
                SpotifyRemote.shared.reconnect()
                currentPlayer = spotifyPlayer
                currentPlayer.play(with: queue)
            case .youtube:
                currentPlayer = youtubePlayer
                YoutubeRemote.shared.start()
                currentPlayer.play(with: queue)
            default: break
            }
        }
    }
    
    
    func skipToNext() {
        currentPlayer.skipToNext()
    }
    
    func skipToPrev() {
        currentPlayer.skipToPrev()
    }
    
    func skipToCurrentPosition() {
        currentPlayer.skipToCurrentPosition()
    }
    
    func playOrPause() {
        currentPlayer.playOrPause()
    }
    
    func stop() {
        currentPlayer.stop()
    }
    
    func toggleRepeatMode() {
        currentPlayer.toggleRepeatMode()
    }
    
    func toggleShuffleMode(completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        currentPlayer.toggleShuffleMode(completion: completion, error: error)
    }
    
    func setCurrentPlaybackTime(with time: TimeInterval) {
        currentPlayer.setCurrentPlaybackTime(with: time)
    }
}

extension Player: SpotifyRemoteDelegate {
    func remote(spotifyRemote: SpotifyRemote, didAuthenticate status: Bool) {
        if currentPositionIncremented && status {
            currentPositionIncremented = false
            MusicQueue.shared.currentPosition.value += 1
            spotifyPlayer.updateMiniPlayer()
        }
    }
}
