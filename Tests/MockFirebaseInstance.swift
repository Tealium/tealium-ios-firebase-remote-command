//
//  MockFirebaseInstance.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import FirebaseCore
import TealiumCore
@testable import TealiumFirebase
import TealiumRemoteCommands


class MockFirebaseInstance: FirebaseInstance {
    var _isConfigured = false
    override var isConfigured: Bool {
        get {
            dispatchPrecondition(condition: .onQueue(.main))
            return _isConfigured
        }
        
        
    }

    var createAnalyticsConfigCallCount = 0
    
    var logEventWithParamsCallCount = 0
    
    var logEventWithoutParamsCallCount = 0
    
    var setScreenNameCallCount = 0
    
    var setUserPropertyCallCount = 0
    
    var setUserIdCallCount = 0
    
    var initateConversionCount = 0
    
    var defaultParameters: [String:Any]?

    var consentSettings: [String: String]?
    
    override func configure() {
        dispatchPrecondition(condition: .onQueue(.main))
        _isConfigured = true
    }
    override func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?, _ minimumSessionSeconds: TimeInterval?, _ analyticsEnabled: Bool?, _ logLevel: FirebaseLoggerLevel) {
        createAnalyticsConfigCallCount += 1
        super.createAnalyticsConfig(sessionTimeoutSeconds, minimumSessionSeconds, analyticsEnabled, logLevel)
    }
    
    override func logEvent(_ name: String, _ params: [String : Any]?) {
        logEventWithParamsCallCount += 1
    }
    
    override func setScreenName(_ screenName: String, _ screenClass: String?) {
        setScreenNameCallCount += 1
    }
    
    override func setUserProperty(_ property: String, value: String) {
        setUserPropertyCallCount += 1
    }
    
    override func setUserId(_ id: String) {
        setUserIdCallCount += 1
    }    
    
    override func initiateOnDeviceConversionMeasurement(emailAddress: String) {
        initateConversionCount += 1
    }
    
    override func setDefaultEventParameters(parameters: [String : Any]?) {
        defaultParameters = parameters
    }

    override func setConsent(_ consentSettings: [String : String]) {
        self.consentSettings = consentSettings
    }
}
