//
//  TealiumHelper.swift
//  RemoteCommandModules
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit
import TealiumCore
import TealiumCollect
import TealiumLifecycle
import TealiumTagManagement
import TealiumRemoteCommands
import TealiumFirebase

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "firebase-tag"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
        profile: TealiumConfiguration.profile,
        environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    
    // JSON Remote Command
    let firebaseRemoteCommand = FirebaseRemoteCommand(type: .remote(url: "https://tags.tiqcdn.com/dle/tealiummobile/demo/firebase.json"))

    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.TagManagement, Dispatchers.RemoteCommands]
        
        config.addRemoteCommand(firebaseRemoteCommand)
        
        tealium = Tealium(config: config)
    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumView)
    }

    class func trackScreen(_ view: UIViewController, name: String) {
        TealiumHelper.trackView(title: "screen_view", data: ["screen_name": name, "screen_class": "\(view.classForCoder)"])
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumEvent)
    }

}
