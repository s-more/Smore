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
    
    private var player: YTSwiftyPlayer!
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
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 100, width: myWidth, height: myHeight),
            playerVars: [.videoID(vid_id), .showRelatedVideo(false)])
        
        //screen = YTSwiftyPlayer(
        // Enable auto playback when video is loaded
        player.autoplay = false
        
        // Set player view.
        //view = player
        view.addSubview(player)
//        player.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.view)
//            make.centerY.equalTo(self.view).offset(-NavBarHeight / 2.0)
//            make.width.equalTo(ScreenWidth)
//            make.height.equalTo(playHeight)
//        }
        
        // Set delegate for detect callback information from the player.
        player.delegate = self
        
        // Load the video.
        player.loadPlayer()
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
        player.pauseVideo()
    }
    
    @IBAction func pressForward(_ sender: UIButton) {
        print("Forward")
        player.seek(to: 15, allowSeekAhead: true)
        
    }
    
    @IBAction func pressBack(_ sender: UIButton) {
        print("Backward")
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        print("exiting")
    }
    
}
