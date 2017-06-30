//
//  ViewController.swift
//  ProximitySensor
//
//  Created by Tobias Böttcher on 30.06.17.
//  Copyright © 2017 Tobias Böttcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var counter: UILabel!
    
    @IBAction func resetCounter(_ sender: UIButton) {
        
        //Test
        counter.text = "0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        activateProximitySensor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func proximityChanged(notification:Notification) -> Void {
        print("Changed to: \(UIDevice.current.proximityState)")
        
        if UIDevice.current.proximityState == true  {
            var count = Int(counter.text!)!
            count = count + 1
            counter.text = "\(count)"
        }
    }
    
    
    func activateProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            let nc = NotificationCenter.default
            nc.addObserver(forName: NSNotification.Name.UIDeviceProximityStateDidChange, object: nil, queue: nil, using: proximityChanged)
        }
    }
    
    
}

