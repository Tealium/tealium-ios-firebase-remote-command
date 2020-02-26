//
//  FirebaseTracker.swift
//
//  Created by Christina Sund on 7/11/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAnalytics

@objc
public protocol FirebaseTrackable {
    func createAnalyticsConfig(_ configuration: [AnyHashable: Any])
    func logEvent(_ name: String, _ params: [String: Any]?)
    func setScreenName(_ screenName: String, _ screenClass: String?)
    func setUserProperty(_ property: String, value: String)
    func setUserId(_ id: String)
}

@objc
public class FirebaseTracker: NSObject, FirebaseTrackable {
    
    public override init() { }
    
    public func createAnalyticsConfig(_ configuration: [AnyHashable: Any]) {
        if let sessionTimeoutSeconds = configuration[FirebaseKey.sessionTimeout] as? TimeInterval {
            Analytics.setSessionTimeoutInterval(sessionTimeoutSeconds)
        }
        if let analyticsEnabled = configuration[FirebaseKey.analyticsEnabled] as? Bool {
            Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
        }
        if let logLevel = configuration[FirebaseKey.logLevel] as? FirebaseLoggerLevel {
            FirebaseConfiguration.shared.setLoggerLevel(logLevel)
        }
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
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
