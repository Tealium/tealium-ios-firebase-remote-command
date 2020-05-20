//
//  FirebaseConstants.swift
//  TealiumFirebase
//
//  Created by Christina S on 5/20/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

enum FirebaseConstants {
    
    static let separator: Character = ","
    static let commandId = "firebaseAnalytics"
    static let description = "Firebase Remote Command"
    static let errorPrefix = "Tealium Firebase: "
    
    enum Keys: String {
        case commandName = "command_name"
        case sessionTimeout = "firebase_session_timeout_seconds"
        case minSeconds = "firebase_session_minimum_seconds"
        case analyticsEnabled = "firebase_analytics_enabled"
        case logLevel = "firebase_log_level"
        case eventName = "firebase_event_name"
        case eventParams = "firebase_event_params"
        case screenName = "firebase_screen_name"
        case screenClass = "firebase_screen_class"
        case userPropertyName = "firebase_property_name"
        case userPropertyValue = "firebase_property_value"
        case userId = "firebase_user_id"
        case paramItems = "param_items"
        case items = "items"
    }

    enum Commands: String {
        case config = "config"
        case logEvent = "logevent"
        case setScreenName = "setscreenname"
        case setUserProperty = "setuserproperty"
        case setUserId = "setuserid"
    }
    
}
