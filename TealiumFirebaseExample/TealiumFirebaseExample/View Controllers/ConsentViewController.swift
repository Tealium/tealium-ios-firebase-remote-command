//
//  ConsentViewController.swift
//  TealiumFirebaseExample
//
//  Created by Enrico Zannini on 10/01/24.
//  Copyright © 2024 Christina. All rights reserved.
//

import UIKit

class ConsentViewController: UIViewController {

    @IBOutlet weak var analyticsStorageConsent: UISwitch!
    @IBOutlet weak var adStorageConsent: UISwitch!
    @IBOutlet weak var adUserDataConsent: UISwitch!
    @IBOutlet weak var adPersonalizationConsent: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveConsent(_ sender: Any) {
        TealiumHelper.trackEvent(title: "setconsent", data: [
            "consent_analytics_storage": analyticsStorageConsent.isOn ? "granted" : "denied",
            "consent_ad_storage": adStorageConsent.isOn ? "granted" : "denied",
            "consent_ad_user_data": adUserDataConsent.isOn ? "granted" : "denied",
            "consent_ad_personalization": adPersonalizationConsent.isOn ? "granted" : "denied"
        ])
        self.navigationController?.popViewController(animated: true)
    }
    
}
