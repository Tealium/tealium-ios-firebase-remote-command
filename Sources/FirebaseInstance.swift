//
//  FirebaseInstance.swift
//  TealiumFirebase
//
//  Created by Christina S on 7/11/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

public protocol FirebaseCommand {
    func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?, _ minimumSessionSeconds: TimeInterval?, _ analyticsEnabled: Bool?, _ logLevel: FirebaseLoggerLevel)
    func logEvent(_ name: String, _ params: [String: Any]?)
    func setScreenName(_ screenName: String, _ screenClass: String?)
    func setUserProperty(_ property: String, value: String)
    func setUserId(_ id: String)
    func initiateOnDeviceConversionMeasurement(emailAddress: String)
    func setDefaultEventParameters(parameters: [String: Any]?)
}

public class FirebaseInstance: FirebaseCommand {
    
    public init() { }
    
    public func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?, _ minimumSessionSeconds: TimeInterval?, _ analyticsEnabled: Bool?, _ logLevel: FirebaseLoggerLevel) {
        if let sessionTimeoutSeconds = sessionTimeoutSeconds {
            Analytics.setSessionTimeoutInterval(sessionTimeoutSeconds)
        }
        if let analyticsEnabled = analyticsEnabled {
            Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
        }
        FirebaseConfiguration.shared.setLoggerLevel(logLevel)
        if FirebaseApp.app() == nil {
            DispatchQueue.main.async {
                FirebaseApp.configure()
            }
        }
    }
    
    public func logEvent(_ name: String, _ params: [String : Any]?) {
        Analytics.logEvent(name, parameters: params)
    }
    
    public func setScreenName(_ screenName: String, _ screenClass: String?) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                        AnalyticsParameterScreenClass: screenClass ?? ""])
    }
    
    public func setUserProperty(_ property: String, value: String) {
        if value == "" {
            Analytics.setUserProperty(nil, forName: property)
        } else {
            Analytics.setUserProperty(value, forName: property)
        }
    }
    
    public func setUserId(_ id: String) {
        Analytics.setUserID(id)
    }
    
    public func initiateOnDeviceConversionMeasurement(emailAddress: String) {
        Analytics.initiateOnDeviceConversionMeasurement(emailAddress: emailAddress)
    }
    
    public func setDefaultEventParameters(parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }
}
