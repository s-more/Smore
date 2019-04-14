//
//  YoutubePlayerController.swift
//  smore
//
//  Created by sin on 4/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import WebKit
import YoutubeKit

final class YoutubePlayerController: UIViewController, YTSwiftyPlayerDelegate {
    
    private var yt_player: YTSwiftyPlayer!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    var vid_id: String!
    
    init(videoId id: String) {
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        vid_id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get screen size
        let myWidth = UIScreen.main.bounds.width
        let myHeight = myWidth/16*9
        
        // Create a new player
        yt_player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 100, width: myWidth, height: myHeight),
            playerVars: [.videoID(vid_id), .showRelatedVideo(false), .playsInline(true), .showControls(.hidden)])

        // Enable auto playback when video is loaded
        yt_player.autoplay = false
        
        // Set player view.
        view.addSubview(yt_player)
        
        // Set delegate for detect callback information from the player.
        yt_player.delegate = self
        
        // Load the video.
        yt_player.loadPlayer()
    }
    
    func playerReady(_ player: YTSwiftyPlayer) {}
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {}
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {}
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {}
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {}
    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {}
    func apiDidChange(_ player: YTSwiftyPlayer) {}
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {}
    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {}
    
    
    @IBAction func pressPlay(_ sender: UIButton ) {
        print("Play/Pause")
        yt_player.pauseVideo()
    }
    
    @IBAction func pressForward(_ sender: UIButton) {
        print("Forward")
        yt_player.seek(to: 15, allowSeekAhead: true)
    }
    
    @IBAction func pressBack(_ sender: UIButton) {
        print("Backward")
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        print("exiting")
    }
    
}
