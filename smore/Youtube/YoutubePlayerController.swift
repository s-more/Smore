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
import AVKit
import AVFoundation

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
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 100, width: 1, height: 1),
            playerVars: [.videoID(vid_id), .showRelatedVideo(false), .playsInline(true), .autoplay(true), .showControls(.hidden)])
        
        //screen = YTSwiftyPlayer(
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
        let url = "https://www.youtube.com/watch?v=wfF0zHeU3Zs"
        
        YouTubeAPI.getMP4(with: url, success: { [weak self] data in
//            print(data)
            let newURL = data.first?.url
            let avplayer = AVPlayer(url: newURL!)
            let controller = AVPlayerViewController()
            controller.player = avplayer
            self?.present(controller, animated: true) {
                avplayer.play()
            }
            }, error: { err in
                print(err)
        })
//        YouTubeAPI.getMP4(with: url, success: <#T##(YTMP4Response) -> Void#>, error: <#T##(Error) -> Void#>))
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//        let avplayer = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
//        let controller = AVPlayerViewController()
//        controller.player = avplayer
        
        // Modally present the player and call the player's play() method when complete.
//        present(controller, animated: true) {
//            avplayer.play()
//        }
        print("Play/Pause")
//        player.pauseVideo()
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
