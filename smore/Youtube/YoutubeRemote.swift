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
    
    private override init() {
        super.init()
    }
    
    var playerRemote: YoutubePlayerController?
    
    func play( videoID: String ){
        
    }
    
    func pause(){
        
    }
    
    func resume(){
        
    }
    
    func stop(){
        
    }
    
    func setRepeatMode(){
        
    }
    
    func setShuffle(state: Bool){
    
    }
    
    
}
