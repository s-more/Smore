//
//  YoutubeRemote.swift
//  smore
//
//  Created by Khalil Fleming on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class YoutubeRemote: NSObject {
    static let shared = YoutubeRemote()
    
    var vc: YoutubePlayerController?
    
    var started: Bool
    
    private override init() {
        started = false
        super.init()
    }
    
    var playerRemote: YoutubePlayerController?
    
    func start() {
        if !started {
            //navigationController?.pushViewController(YoutubePlayerController(), animated: true)
            started = true
        }
        
    }
    
    func play( videoID: String ){
        vc?.play(videoID: videoID)
    }
    
    func pause(){
        vc?.pause()
    }
    
    func resume(){
        vc?.resume()
    }
    
    func stop(){
        vc?.stop()
    }
    
    func setRepeatMode(){
        // TODO
    }
    
    func setShuffle(state: Bool){
        // TODO
    }
    
    
}
