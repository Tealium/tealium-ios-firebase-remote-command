//
//  TealiumHelper.swift
//  RemoteCommandModules
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import TealiumFirebase

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "firebase-tag"
    static let environment = "qa"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
        profile: TealiumConfiguration.profile,
        environment: TealiumConfiguration.environment)

    var tealium: Tealium?

    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.logLevel = .verbose
        tealium = Tealium(config: config,
            enableCompletion: { [weak self] _ in
                guard let self = self else { return }
                guard let remoteCommands = self.tealium?.remoteCommands() else {
                    return
                }
                // MARK: Firebase
                let firebaseRemoteCommand = FirebaseRemoteCommand().remoteCommand()
                remoteCommands.add(firebaseRemoteCommand)
            })

    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

    class func trackScreen(_ view: UIViewController, name: String) {
        TealiumHelper.trackView(title: "screen_view", data: ["screen_name": name, "screen_class": "\(view.classForCoder)"])
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

}
