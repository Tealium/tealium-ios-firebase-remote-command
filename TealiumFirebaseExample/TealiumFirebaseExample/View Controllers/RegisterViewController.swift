//
//  RegisterViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina S on 7/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/flat-icons 🙏
class RegisterViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "register")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        fullName.delegate = self
        username.delegate = self
        password.delegate = self
    }

    @IBAction func onRegister(_ sender: Any) {
        TealiumHelper.trackEvent(title: "user_register", data: [RegisterViewController.customerId: "ABC123", RegisterViewController.signUpMethod: "apple", RegisterViewController.fullName: fullName.text!])
    }

}

extension RegisterViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fullName.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension RegisterViewController {
    static let customerId = "customer_id"
    static let signUpMethod = "signup_method"
    static let fullName = "customer_full_name"
}
