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

/**
 A set of APIs to work with Apple Music.
 - uses the prefix `APM`
 */
enum AppleMusicAPI {
    private static let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlY1MjU0OUs3SzYifQ.eyJpYXQiOjE1NDkxMzM3NTgsImV4cCI6MTU2NDY4NTc1OCwiaXNzIjoiTkRCVEs5OFZMMyJ9.r3a_fQH_5mAlrI9OeLHfTZ4mU486mgXRVr3xoD0yq1mR4oSlpEiQorwhaGXORZ0ESRE0xHcQzs8TOkaYCaMoKg"
    private static let cloudServiceController = SKCloudServiceController()
    static let authHeaders = ["Authorization": "Bearer \(developerToken)"]
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
    
    /**
     Can show subscription view **only when .musicCatalogPlayback is absent and .musicCatalogSubscriptionEligible is enabled.**
     */
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
    
    static func requestCountryCode(completion: @escaping (String?, Error?) -> Void) {
        cloudServiceController.requestStorefrontCountryCode { countryCode, error in
            completion(countryCode, error)
        }
    }
}
