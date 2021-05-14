//
//  GamingViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina S on 7/19/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

class GamingViewController: UIViewController {

    @IBOutlet weak var startTutorialButton: UIButton!
    @IBOutlet weak var stopTutorialButton: UIButton!
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!

    var data = [String: Any]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "gaming")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    

    @objc func share() {
        TealiumHelper.trackEvent(title: "share", data: [GamingViewController.contentType: "gaming screen", GamingViewController.shareId: "gamqwe123", "event_title": EventNames.lookup["share"]!])
        let vc = UIActivityViewController(activityItems: ["Gaming"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func spendCurrency(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "spend_currency", data: [GamingViewController.productName: ["jewels"],
                                                                "currency_type": GamingViewController.tokens,
                                                                "number_of_tokens": 50,
                                                                "event_title": EventNames.lookup["spend_currency"]!])
    }
    
    @IBAction func earnCurrency(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "earn_currency",
                                 data: [GamingViewController.currencyType: "tokens",
                                                               GamingViewController.tokens: 100,
                                                               "event_title": EventNames.lookup["earn_currency"]!])
    }
    
    @IBAction func achievementSwitch(_ sender: UISwitch) {
        if sender.isOn {
            TealiumHelper.trackEvent(title: "unlock_achievement", data: [GamingViewController.achievementId: "\(Int.random(in: 1...1000))"])
            achievementLabel.text = "Lock Achievement"
        } else {
            achievementLabel.text = "Unlock Achievement"
        }
        
    }
    
    @IBAction func levelStepper(_ sender: UIStepper) {
        levelLabel.text = String(Int(sender.value))
        data[GamingViewController.level] = String(Int(sender.value))
        data[GamingViewController.character] = "mario"
        data["event_title"] = EventNames.lookup["level_up"]!
        TealiumHelper.trackEvent(title: "level_up", data: data)
    }
    
    
    @IBAction func startTutorial(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "start_tutorial", data: nil)
    }
    
    @IBAction func stopTutorial(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "stop_tutorial", data: nil)
    }
    
    @IBAction func postScore(_ sender: Any) {
        data[GamingViewController.score] = Int.random(in: 1...1000) * 1000
        data["event_title"] = EventNames.lookup["record_score"]!
        TealiumHelper.trackEvent(title: "record_score", data: data)
    }

}

extension GamingViewController {
    static let contentType = "content_type"
    static let shareId = "share_id"
    static let productName = "product_name"
    static let currencyType = "currency_type"
    static let tokens = "tokens"
    static let achievementId = "achievement_id"
    static let level = "current_level"
    static let character = "character"
    static let score = "score"
}
