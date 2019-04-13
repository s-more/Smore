//
//  SpotifyRemote.swift
//  smore
//
//  Created by Colin Williamson on 3/24/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation


class SpotifyRemote: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    let SpotifyClientID = "239230def9e84becac4333eaa80161df"
    let SpotifyRedirectURL = URL(string: "smore://return")!
    weak var delegate: SpotifyRemoteDelegate?
    
    static let shared = SpotifyRemote()
    
    override init () {
        super.init()
    }
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    //    Instantiation of the Session Manager
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {[weak self] _, error in
                if let error = error {
                    print("APPREMOTE CALLBACK ERROR")
                    print(error as NSError)
                }
            }
        }
    }
    
    private lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "https://smore-token-swamp.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://smore-token-swamp.herokuapp.com/api/refresh_token")
        return configuration
    }()
    
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Connected")
        // Connection was successful, you can begin issuing commands
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    //    Connect to spotify after successful auth
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        debugPrint("Track name: %@", playerState.track.name)
    }
    
    func spotifyLogin() {
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
}
