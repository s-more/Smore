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
import Kingfisher

class YoutubePlayerController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var vid_id: String!
    var vid_url: URL!
    var isPlaying = false
    let avplayer = AVPlayer()
    let avcontroller = AVPlayerViewController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        self.avcontroller.player = self.avplayer
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avcontroller.player?.currentItem)
    }
    
    init( videoID: String ) {
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        self.avcontroller.player = self.avplayer
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avcontroller.player?.currentItem)
        loadVideo(videoID: videoID)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YoutubeRemote.shared.vc = self
        
        loadImage()
    }

    func displayVideo(){
        let newItem = AVPlayerItem(url: self.vid_url)
        self.avcontroller.player?.replaceCurrentItem(with: newItem)
        self.addChild(self.avcontroller)
        self.avcontroller.player?.play()
        
        //loadImage()
    }
    
    func loadVideo(videoID: String ){
        vid_id = videoID
        print("THIS IS THE VIDEO ID: \(videoID) !@#@$%$#^")
        let temp_vid_url = "https://www.youtube.com/watch?v=\(videoID)"
        
        loadImage()
        
        YouTubeAPI.getMP4(with: temp_vid_url, success: { data in
            self.vid_url = data.first?.url
            self.displayVideo()
        }, error: { err in
            print(err)
        })
    }
    
    func loadImage() {
        print("Loading new image")
        let imageLink = MusicQueue.shared.currentSong.imageLink
        thumbnail.image = nil
        thumbnail.kf.setImage(with: imageLink, placeholder: UIImage(named: "youtubePlaceholder"))
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
        //loadVideo(videoID: "fYGPcfUqzL0")
        Player.shared.skipToNext()
    }
    
    @IBAction func pressBack(_ sender: UIButton) {
        print("Backward")
        Player.shared.skipToPrev()
        //loadVideo(videoID: "2ZIpFytCSVc")
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        print("exiting")
        dismiss(animated: true)
    }
    
    @IBAction func moreActions(_ sender: Any) {
        UIAlertController.showMoreAction(from: MusicQueue.shared.currentSong, on: self)
    }
    
    
    func play( videoID: String ){
        loadVideo(videoID: videoID)
    }
    
    func pause(){
         self.avcontroller.player?.pause()
    }
    
    func resume(){
         self.avcontroller.player?.play()
    }
    
    func stop(){
         self.avcontroller.player?.pause()
        dismiss(animated: true)
    }
    
    @objc func endOfVideo(){
        print("End of vid @!#!@$@#")
        Player.shared.skipToNext()
    }
    
}
