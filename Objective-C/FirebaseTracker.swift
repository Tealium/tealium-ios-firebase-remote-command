//
//  FirebaseTracker.swift
//  TealiumFirebase
//
//  Created by Christina S on 05/20/20.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAnalytics

@objc
public protocol FirebaseTrackable {
    func createAnalyticsConfig(_ configuration: [String: Any])
    func logEvent(_ name: String, _ params: [String: Any]?)
    func setScreenName(_ screenName: String, _ screenClass: String?)
    func setUserProperty(_ property: String, value: String)
    func setUserId(_ id: String)
}

@objc
public class FirebaseTracker: NSObject, FirebaseTrackable {
    
    public override init() { }
    
    public func createAnalyticsConfig(_ configuration: [String: Any]) {
        if let sessionTimeoutSeconds = configuration[.sessionTimeout] as? TimeInterval {
            Analytics.setSessionTimeoutInterval(sessionTimeoutSeconds)
        }
        if let analyticsEnabled = configuration[.analyticsEnabled] as? Bool {
            Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
        }
        if let logLevel = configuration[.logLevel] as? FirebaseLoggerLevel {
            FirebaseConfiguration.shared.setLoggerLevel(logLevel)
        }
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
        DispatchQueue.main.async {
            Analytics.setScreenName(screenName, screenClass: screenClass)
        }
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
    
}
