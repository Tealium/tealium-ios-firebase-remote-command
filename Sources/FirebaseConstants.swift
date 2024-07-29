//
//  FirebaseConstants.swift
//  TealiumFirebase
//
//  Created by Christina S on 5/20/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum FirebaseConstants {
    
    static let commandName = "command_name"
    static let separator: Character = ","
    static let commandId = "firebaseAnalytics"
    static let description = "Firebase Remote Command"
    static let errorPrefix = "Tealium Firebase: "
    static let version = "3.3.0"
    
    enum Keys {
        static let sessionTimeout = "firebase_session_timeout_seconds"
        static let minSeconds = "firebase_session_minimum_seconds"
        static let analyticsEnabled = "firebase_analytics_enabled"
        static let logLevel = "firebase_log_level"
        static let eventName = "firebase_event_name"
        static let eventParams = "firebase_event_params"
        static let eventKey = "event"
        static let screenName = "firebase_screen_name"
        static let screenClass = "firebase_screen_class"
        static let userPropertyName = "firebase_property_name"
        static let userPropertyValue = "firebase_property_value"
        static let userId = "firebase_user_id"
        static let paramItems = "param_items"
        static let items = "items"
        static let productId = "param_item_id"
        static let emailAddress = "param_email_address"
        static let defaultParams = "default"
        static let tagDefaultParams = "firebase_default_params"
        static let consentSettings = "firebase_consent_settings"
    }

    enum Commands: String {
        case config = "config"
        case logEvent = "logevent"
        case setScreenName = "setscreenname"
        case setUserProperty = "setuserproperty"
        case setUserId = "setuserid"
        case initiateConversionMeasurement = "initiateconversionmeasurement"
        case setDefaultParameters = "setdefaultparameters"
        case setConsent = "setconsent"
    }
    
}


extension ConsentType {
    static func from(_ consentString: String) -> ConsentType {
        switch consentString {
        case "ad_storage":
            return .adStorage
        case "analytics_storage":
            return .analyticsStorage
        default:
            return ConsentType(rawValue: consentString)
        }
    }
}

extension ConsentStatus {
    static func from(_ statusString: String) -> ConsentStatus {
        switch statusString {
        case "granted":
            return .granted
        case "denied":
            return .denied
        default:
            return ConsentStatus(rawValue: statusString)
        }
    }
}
