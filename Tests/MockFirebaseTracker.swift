//
//  MockFirebaseTracker.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumFirebase
import TealiumRemoteCommands
@testable import Firebase

class MockFirebaseTracker: FirebaseTrackable {

    var createAnalyticsConfigCallCount = 0
    
    var logEventWithParamsCallCount = 0
    
    var logEventWithoutParamsCallCount = 0
    
    var setScreenNameCallCount = 0
    
    var setUserPropertyCallCount = 0
    
    var setUserIdCallCount = 0
    
    func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?, _ minimumSessionSeconds: TimeInterval?, _ analyticsEnabled: Bool?, _ logLevel: FirebaseLoggerLevel) {
        createAnalyticsConfigCallCount += 1
    }
    
    func logEvent(_ name: String, _ params: [String : Any]?) {
        guard let _ = params else {
            logEventWithoutParamsCallCount += 1
            return
        }
        logEventWithParamsCallCount += 1
    }
    
    func setScreenName(_ screenName: String, _ screenClass: String?) {
        setScreenNameCallCount += 1
    }
    
    func setUserProperty(_ property: String, value: String) {
        setUserPropertyCallCount += 1
    }
    
    func setUserId(_ id: String) {
        setUserIdCallCount += 1
    }    
    
}
