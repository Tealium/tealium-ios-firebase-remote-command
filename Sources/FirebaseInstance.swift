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
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
#endif

public protocol FirebaseCommand {
    func onReady(_ onReady: @escaping () -> Void)
    func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?,
                               _ minimumSessionSeconds: TimeInterval?,
                               _ analyticsEnabled: Bool?,
                               _ logLevel: FirebaseLoggerLevel)
    func logEvent(_ name: String, _ params: [String: Any]?)
    func setScreenName(_ screenName: String, _ screenClass: String?)
    func setUserProperty(_ property: String, value: String)
    func setUserId(_ id: String)
    func initiateOnDeviceConversionMeasurement(emailAddress: String)
    func setDefaultEventParameters(parameters: [String: Any]?)
}

public class FirebaseInstance: FirebaseCommand {
    
    public init() { }
    
    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    
    var isConfigured: Bool {
        // Analytics is only logged on default instance
        FirebaseApp.app() != nil
    }
    /// Waits for the default FirebaseApp to be configured for the first time and then calls the completion block. If the default app gets deleted later this won't wait anymore.
    public func onReady(_ onReady: @escaping () -> Void) {
        guard !isConfigured else {
            if _onReady.last() == nil {
                _onReady.publish()
            }
            onReady()
            return
        }
        _onReady.subscribeOnce(onReady)
    }
    
    public func createAnalyticsConfig(_ sessionTimeoutSeconds: TimeInterval?,
                                      _ minimumSessionSeconds: TimeInterval?,
                                      _ analyticsEnabled: Bool?,
                                      _ logLevel: FirebaseLoggerLevel) {
        if let sessionTimeoutSeconds = sessionTimeoutSeconds {
            Analytics.setSessionTimeoutInterval(sessionTimeoutSeconds)
        }
        if let analyticsEnabled = analyticsEnabled {
            Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
        }
        FirebaseConfiguration.shared.setLoggerLevel(logLevel)
        if !isConfigured {
            DispatchQueue.main.async {
                FirebaseApp.configure()
                TealiumQueues.backgroundSerialQueue.async {
                    self._onReady.publish()
                }
            }
        } else {
            _onReady.publish()
        }
    }
    
    public func logEvent(_ name: String, _ params: [String : Any]?) {
        onReady {
            Analytics.logEvent(name, parameters: params)
        }
    }
    
    public func setScreenName(_ screenName: String, _ screenClass: String?) {
        onReady {
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [
                                AnalyticsParameterScreenName: screenName,
                                AnalyticsParameterScreenClass: screenClass ?? ""])
        }
    }
    
    public func setUserProperty(_ property: String, value: String) {
        onReady {
            if value == "" {
                Analytics.setUserProperty(nil, forName: property)
            } else {
                Analytics.setUserProperty(value, forName: property)
            }
        }
    }
    
    public func setUserId(_ id: String) {
        onReady {
            Analytics.setUserID(id)
        }
    }
    
    public func initiateOnDeviceConversionMeasurement(emailAddress: String) {
        onReady {
            Analytics.initiateOnDeviceConversionMeasurement(emailAddress: emailAddress)
        }
    }
    
    public func setDefaultEventParameters(parameters: [String: Any]?) {
        onReady {
            Analytics.setDefaultEventParameters(parameters)
        }
    }
}
