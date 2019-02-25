//
//  AppleMusicAPI+Rx.swift
//  smore
//
//  Created by Jing Wei Li on 2/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import RxSwift
import StoreKit

extension AppleMusicAPI {
    /// Reactive extensions for AppleMusicAPI.
    enum rx {
        static var authorized: Observable<Bool> {
            return Observable.create { observable in
                if SKCloudServiceController.authorizationStatus() == .authorized {
                    observable.onNext(true)
                    observable.onCompleted()
                } else {
                    observable.onNext(false)
                    requestAuthorization { _, status in
                        observable.onNext(status == .authorized)
                        observable.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        static var needsSubscription: Observable<SKCloudServiceSetupViewController?> {
            return Observable.create { observable in
                requestCapabilities { subscribeVC, error in
                    if let error = error {
                        observable.onError(error)
                    }
                    observable.onNext(subscribeVC)
                    observable.onCompleted()
                }
                return Disposables.create()
            }
        }
        
        
        /// We are not calling `onError()` on the observable b/c we don't want the search operation
        /// to abort.
        static func searchResults(from term: String) -> Observable<(APMSearch.APMSearchResults?, Error?)> {
            return Observable.create { observable in
                AppleMusicAPI.searchCatalog(with: term, success: { results in
                    observable.onNext((results, nil))
                    observable.onCompleted()
                }, error: { error in
                    observable.onNext((nil, error))
                    observable.onCompleted()
                })
                return Disposables.create()
            }
        }
    }
}
