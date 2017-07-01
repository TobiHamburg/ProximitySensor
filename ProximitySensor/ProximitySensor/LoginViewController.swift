//
//  LoginViewController.swift
//  ProximitySensor
//
//  Created by Tobias Böttcher on 30.06.17.
//  Copyright © 2017 Tobias Böttcher. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToApp = "LoginToApp"
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController - viewDidLoad")
        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                print("LoginViewController - performSegue")
                self.performSegue(withIdentifier: self.loginToApp, sender: nil)
            }
        }
    }
    
    
    func signIn() {
        print("LoginViewController - signIn")
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!,
                           password: textFieldLoginPassword.text!)
    }
    
    
    @IBAction func loginDidTouch(_ sender: UIButton) {
        print("LoginViewController - loginDidTouch")
        self.signIn()
    }
    
    @IBAction func registerDidTouch(_ sender: UIButton) {
        print("LoginViewController - registerDidTouch")
        Auth.auth().createUser(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!) { user, error in
                                if error == nil {
                                    self.signIn()
                                }
        }
    }
}
