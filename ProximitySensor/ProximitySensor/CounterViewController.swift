//
//  ViewController.swift
//  ProximitySensor
//
//  Created by Tobias Böttcher on 30.06.17.
//  Copyright © 2017 Tobias Böttcher. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CounterViewController: UIViewController {
    
    let ref = Database.database().reference(withPath: "users")
    let refChallenge = Database.database().reference(withPath: "challenge")
    var user: MyUser!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var challengePartnerNameLabel: UILabel!
    @IBOutlet weak var challengePartnerCounterLabel: UILabel!
    
    @IBAction func resetCounter(_ sender: UIButton) {
        
        counter.text = "0"
    }
    
    @IBAction func startChallengeDidTouch(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Begin Challenge",
                                      message: "Type a friends name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Do it!",
                                       style: .default) { action in
                                        
                                        
                                        print("your challenge partner: \(alert.textFields![0].text!)")
                                        let challengeParterName = alert.textFields![0].text!
                                        self.retrieveDataFromUser(name: challengeParterName)
                                        
                                        }
        
        alert.addTextField { textChallengePartner in
            textChallengePartner.placeholder = "Username"
        }

        
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func retrieveDataFromUser(name: String) {
        print("retrieveDataFromUser: \(name)")
        
        self.challengePartnerNameLabel.text = name
        self.challengePartnerNameLabel.isHidden = false
        self.challengePartnerCounterLabel.text = "0"
        self.challengePartnerCounterLabel.isHidden = false
        
        self.refChallenge.child(name).observe(.value, with: { snapshot in
        
            if snapshot.exists() {
                let dictionary: [String: Int] = (snapshot.value as! NSDictionary) as! [String : Int]
                
                self.challengePartnerCounterLabel.text = "\(dictionary["count"] ?? 0)"
            } else {
                self.challengePartnerCounterLabel.text = "0"
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - viewDidLoad")
        self.hideKeyboardWhenTappedAround()
        activateProximitySensor()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = MyUser(authData: user)
        }

    }
    
    func proximityChanged(notification:Notification) -> Void {
        print("ViewController - Changed to: \(UIDevice.current.proximityState)")
        
        if UIDevice.current.proximityState == true  {
            var count = 0
            if counter != nil && counter.text != nil {
            count = Int(counter.text!)!
            }
            count = count + 1
            counter.text = "\(count)"
            
            user.count = count
            self.refChallenge.child(userName.text!).setValue([
                "count" : count
                ]
)
        }
    }
    
    
    func activateProximitySensor() {
        print("ViewController - activateProximitySensor")
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            let nc = NotificationCenter.default
            nc.addObserver(forName: NSNotification.Name.UIDeviceProximityStateDidChange, object: nil, queue: nil, using: proximityChanged)
            print("notification observer added")
        }
    }
    
    
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

