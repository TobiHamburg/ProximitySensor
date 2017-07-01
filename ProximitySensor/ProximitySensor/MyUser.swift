//
//  MyUser.swift
//  ProximitySensor
//
//  Created by Tobias Böttcher on 01.07.17.
//  Copyright © 2017 Tobias Böttcher. All rights reserved.
//

import Foundation
import FirebaseAuth

struct MyUser {
    
    let uid: String
    let email: String
    var count: Int = 0
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
        count = 0
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.count = 0
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "email": email,
            "count": count
        ]
    }
    
}

