//
//  AppDelegate.swift
//  smore
//
//  Created by Jing Wei Li on 1/27/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var first_auth = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        if UserDefaults.isFirstLaunch {
        // Skipping the YT Login Screen breaks the search
            let welcomeNagivation = UINavigationController(rootViewController: WelcomeViewController())
            window?.rootViewController = welcomeNagivation
        } else {
            window?.rootViewController = TabBarViewController()
        }
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        print("reign active")
        if SpotifyRemote.shared.appRemote.isConnected {
            print("is connected")
            SpotifyRemote.shared.appRemote.disconnect()
        }
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("did become active")

        if let _ = SpotifyRemote.shared.appRemote.connectionParameters.accessToken {
            print("accessToken")
            SpotifyRemote.shared.appRemote.connect()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Player.shared.stop()
    }

    //    Successful login auth callback
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if ( true ) { // TODO
            print("successful login auth")
            SpotifyRemote.shared.sessionManager.application(app, open: url, options: options)
            SpotifyRemote.shared.delegate?.remote(spotifyRemote: SpotifyRemote.shared, didAuthenticate: true)
            first_auth = false
            //return true
        }
        if ( true ) { // TODO
            print("Youtube login auth")
            return GIDSignIn.sharedInstance().handle(url as URL?,
                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
    }
    
    
}

extension AppDelegate: GIDSignInDelegate {
    
    // Operation on signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            /*let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // */
            print("Youtube Signed in")
        }
    }
    
    // Operation on signout
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("Youtube Signed Out")
    }
    
    
}
