//
//  MockFirebaseInstance.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import FirebaseCore
@testable import TealiumFirebase
import TealiumRemoteCommands


class MockFirebaseInstance: FirebaseCommand {
    func onReady(_ onReady: @escaping () -> Void) {
        onReady()
    }

    var createAnalyticsConfigCallCount = 0
    
    var logEventWithParamsCallCount = 0
    
    var logEventWithoutParamsCallCount = 0
    
    var setScreenNameCallCount = 0
    
    var setUserPropertyCallCount = 0
    
    var setUserIdCallCount = 0
    
    var initateConversionCount = 0
    
    var defaultParameters: [String:Any]?
    
    func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?, _ minimumSessionSeconds: TimeInterval?, _ analyticsEnabled: Bool?, _ logLevel: FirebaseLoggerLevel) {
        createAnalyticsConfigCallCount += 1
    }
    
    func logEvent(_ name: String, _ params: [String : Any]?) {
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
    
    func initiateOnDeviceConversionMeasurement(emailAddress: String) {
        initateConversionCount += 1
    }
    
    func setDefaultEventParameters(parameters: [String : Any]?) {
        defaultParameters = parameters
    }
}
