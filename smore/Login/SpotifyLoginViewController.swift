//
//  SpotifyLoginViewController.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpotifyLoginViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    let bag = DisposeBag()
    
    init() {
        super.init(nibName: "SpotifyLoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addRoundCorners()
        // Do any additional setup after loading the view.
        let colors = [
            UIColor(red: 0, green: 220/255, blue: 77/255, alpha: 1),
            UIColor(red: 18/255, green: 138/255, blue: 74/255, alpha: 1)
        ]
        loginButton.addGradient(colors: colors)
    }
    
    
    @IBAction func skip(_ sender: UIButton) {
        navigationController?.pushViewController(SoundcloudLoginViewController(), animated: true)
    }
    
    // MARK: Spotify Session Management
    
    // Configuration for Smore Spotify App
    fileprivate let SpotifyClientID = "239230def9e84becac4333eaa80161df"
    fileprivate let SpotifyRedirectURL = URL(string: "spotify-login-sdk-test-app://spotify-login-callback")!
    

    lazy var configuration: SPTConfiguration = {
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
    
    //    SPT Session Manager Delegate Stubs
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    //    Instantiation of the Session Manager
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    //    OnClick of Auth button, initiate spotify session
    @IBAction func loginSpotifyUser(_ sender: UIButton) {
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
//        navigationController?.pushViewController(SoundcloudLoginViewController(), animated: true)
    }
        
    // MARK: Spotify App Remote
    
    //    App Remote function stubs
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        debugPrint("Track name: %@", playerState.track.name)
    }
    
    // App Remote init
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    //    Connect to spotify after successful auth
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Success")
        print(session.accessToken)
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
        appRemote.playerAPI?.delegate = self
        print(appRemote.isConnected)
//        self.appRemote.playerAPI?.skip(toNext: nil)
    }
    
    
    // AppRemote State Changes
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Connected")
        // Connection was successful, you can begin issuing commands
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("reign active")
        if self.appRemote.isConnected {
            print("is connected")
            self.appRemote.disconnect()
        }
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("did become active")
        if let _ = self.appRemote.connectionParameters.accessToken {
            print("accessToken")
            self.appRemote.connect()
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        print("play")
        self.appRemote.playerAPI?.skip(toNext: nil)
    }
}
