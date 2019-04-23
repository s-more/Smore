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
import MarqueeLabel

class YoutubePlayerController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var songNameLabel: MarqueeLabel!
    @IBOutlet weak var songSubtitleLabel: MarqueeLabel!
    
    var vid_id: String!
    var vid_url: URL!
    var isPlaying = false
    let avplayer = AVPlayer()
    let avcontroller = AVPlayerViewController()
    let activityIndicator = LottieActivityIndicator.smoreExplosion
    let song: Song?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        song = nil
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        self.avcontroller.player = self.avplayer
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avcontroller.player?.currentItem)
    }
    
    init( videoID: String ) {
        song = nil
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        self.avcontroller.player = self.avplayer
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avcontroller.player?.currentItem)
        vid_id = videoID
    }
    
    init(song: Song) {
        self.avcontroller.player = self.avplayer
        vid_id = song.playableString
        self.song = song
        super.init(nibName: "YoutubePlayer", bundle: Bundle.main)
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avcontroller.player?.currentItem)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YoutubeRemote.shared.vc = self
        songNameLabel.text = song?.name
        songSubtitleLabel.text = song?.artistName
        loadVideo(videoID: vid_id)
    }

    func displayVideo(){
        let newItem = AVPlayerItem(url: self.vid_url)
        self.avcontroller.player?.replaceCurrentItem(with: newItem)
        self.addChild(self.avcontroller)
        self.avcontroller.player?.play()
        
        //loadImage()
    }
    
    func loadVideo(videoID: String ){
        print("THIS IS THE VIDEO ID: \(videoID) !@#@$%$#^")
        let temp_vid_url = "https://www.youtube.com/watch?v=\(videoID)"

        view.addSubview(activityIndicator)
        loadImage()
        
        YouTubeAPI.getMP4(with: temp_vid_url, success: { [weak self] data in
            self?.vid_url = data.first?.url
            self?.activityIndicator.stop()
            self?.playButton.sendActions(for: .touchUpInside)
            self?.displayVideo()
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
            playButton.setImage(PlayerState.playing.image, for: .normal)
        } else {
            self.isPlaying = false
            self.avcontroller.player?.pause()
            playButton.setImage(PlayerState.notPlaying.image, for: .normal)
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
        dismiss(animated: true) {
            MiniPlayer.shared.resetLocation()
        }
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
