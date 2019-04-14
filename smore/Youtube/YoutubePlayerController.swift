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
    var isPlaying = false
    let avplayer = AVPlayer()
    let avcontroller = AVPlayerViewController()
    
    init(videoId id: String) {
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        vid_id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://www.youtube.com/watch?v=wfF0zHeU3Zs"
        
        YouTubeAPI.getMP4(with: url, success: { data in
            let newURL = data.first?.url
            let newItem = AVPlayerItem(url: newURL!)
            
            self.avcontroller.player = self.avplayer
            self.avcontroller.player?.replaceCurrentItem(with: newItem)
            self.addChild(self.avcontroller)
        }, error: { err in
            print(err)
        })
    
    }
    
    
    @IBAction func pressPlay(_ sender: UIButton ) {
        print("Play/Pause")
        if self.isPlaying == false {
            self.isPlaying = true
            self.avcontroller.player?.play()
        } else {
            self.isPlaying = false
            self.avcontroller.player?.pause()
        }
    }
    
    @IBAction func pressForward(_ sender: UIButton) {
        print("Forward")
    }
    
    @IBAction func pressBack(_ sender: UIButton) {
        print("Backward")
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        print("exiting")
    }
    
}
