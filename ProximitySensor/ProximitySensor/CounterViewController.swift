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
    var user: MyUser!
    var usersRef = Database.database().reference(withPath: "online")
    
    @IBOutlet weak var counter: UILabel!
    
    @IBAction func resetCounter(_ sender: UIButton) {
        
        counter.text = "0"
    }
    
    @IBAction func startChallengeDidTouch(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - viewDidLoad")
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
            self.ref.setValue(user.toAnyObject())
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

