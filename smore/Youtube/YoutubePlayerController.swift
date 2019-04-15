//
//  YoutubePlayerController.swift
//  smore
//
//  Created by sin on 4/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class YoutubePlayerController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    var vid_id: String!
    var vid_url: URL!
    var isPlaying = false
    let avplayer = AVPlayer()
    let avcontroller = AVPlayerViewController()
    
    init(videoId id: String) {
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        self.avcontroller.player = self.avplayer
        vid_id = id
        loadVideo(videoID: "wfF0zHeU3Zs")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func displayVideo(){
        let newItem = AVPlayerItem(url: self.vid_url)
        self.avcontroller.player?.replaceCurrentItem(with: newItem)
        self.addChild(self.avcontroller)
    }
    
    func loadVideo(videoID: String ){
        vid_id = videoID
        
        let temp_vid_url = "https://www.youtube.com/watch?v=\(videoID)"
        
        YouTubeAPI.getMP4(with: temp_vid_url, success: { data in
            self.vid_url = data.first?.url
            self.displayVideo()
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
        loadVideo(videoID: "fYGPcfUqzL0")
    }
    
    @IBAction func pressBack(_ sender: UIButton) {
        print("Backward")
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        print("exiting")
    }
    
}
