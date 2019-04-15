//
//  AppleMusicAPI.swift
//  smore
//
//  Created by Jing Wei Li on 2/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire
import StoreKit

/// A set of APIs to work with Apple Music.
/// - uses the prefix `APM`
enum AppleMusicAPI {
    private static let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlY1MjU0OUs3SzYifQ.eyJpYXQiOjE1NDkxMzM3NTgsImV4cCI6MTU2NDY4NTc1OCwiaXNzIjoiTkRCVEs5OFZMMyJ9.r3a_fQH_5mAlrI9OeLHfTZ4mU486mgXRVr3xoD0yq1mR4oSlpEiQorwhaGXORZ0ESRE0xHcQzs8TOkaYCaMoKg"
    private static let userToken = "Ag1F1wB1M6jt5NUNg/uOZAn6lprh34jQ8D1cQ3+338y/ZhVuzwcKA0CCrpaDUOHyiR1Jh0nb2XLtLdU613d99KsVh4m4JBDWirPxLRa4XrYVkg9i2QwR0LfYx+K/RwS4kT8a3A2PGPxiTOcCZWikJjLHGmKQqkX0+o+0dFWI1iNmFUl+q/WeqPDg5KjI1DQNL2MfvcP4ZrBH6he6hUED9HqRFdOMZfpQSkd9RUoIgW9tGI0U5A=="
    private static let cloudServiceController = SKCloudServiceController()
    static let authHeaders = ["Authorization": "Bearer \(developerToken)"]
    static let authHeaderWithUserToken = [
        "Authorization": "Bearer \(developerToken)",
        "Music-User-Token": userToken
    ]
    static let countryCode = "us"
    
    // MARK: Authorization and Capabilities
    
    static func isAuthorized() -> Bool {
        return SKCloudServiceController.authorizationStatus() == .authorized
    }
    
    static func requestAuthorization(completion: @escaping (Bool, SKCloudServiceAuthorizationStatus) -> Void) {
        SKCloudServiceController.requestAuthorization { status in
            switch status {
            case .denied, .restricted, .notDetermined:
                completion(false, status)
            case .authorized:
                completion(true, status)
            }
        }
    }
    
    /// Can show subscription view **only when .musicCatalogPlayback is absent
    ///and .musicCatalogSubscriptionEligible is enabled.**
    static func requestCapabilities(
        needsSubscription: @escaping (SKCloudServiceSetupViewController?, Error?) -> Void) {
        cloudServiceController.requestCapabilities { capability, error in
            if let err = error {
                print("🎃Error: \(err.localizedDescription)")
            }
            let canPlay = capability.contains(.musicCatalogPlayback)
            let canAdd = capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary)
            guard canAdd else {
                needsSubscription(nil, NSError(domain: "Cannot Add", code: 0, userInfo: nil))
                return
            }
            let canSubscribe = capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible)
            if !canPlay && canSubscribe {
                let setupVC = SKCloudServiceSetupViewController()
                let setupOptions: [SKCloudServiceSetupOptionsKey: Any] = [
                    .action: SKCloudServiceSetupAction.subscribe,
                    .messageIdentifier: SKCloudServiceSetupMessageIdentifier.join
                ]
                setupVC.load(options: setupOptions, completionHandler: { success, error in
                    if error != nil {
                        print("👺Error: \(error?.localizedDescription ?? "")")
                        needsSubscription(nil, error)
                    } else if success {
                        needsSubscription(setupVC, nil)
                    }
                })
            } else {
                needsSubscription(nil, nil)
            }
        }
    }
    
    static func requestUserToken(completion: @escaping (String) -> Void, error: @escaping (Error) -> Void) {
        cloudServiceController.requestUserToken(forDeveloperToken: developerToken) { token, err in
            if let err = err {
                error(err)
                return
            }
            
            if let token = token {
                completion(token)
            } else {
                error(NSError(domain: "Invalid user token obtained", code: 0, userInfo: nil))
            }
        }
    }
    
    static func requestCountryCode(completion: @escaping (String?, Error?) -> Void) {
        cloudServiceController.requestStorefrontCountryCode { countryCode, error in
            completion(countryCode, error)
        }
    }
}
