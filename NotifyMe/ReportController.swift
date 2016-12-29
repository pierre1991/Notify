//
//  ReportController.swift
//  NotifyMe
//
//  Created by Pierre on 12/28/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class ReportController {
    
    static func reportUser(_ user: User) {
        FirebaseController.base.child("reports").childByAutoId().setValue(user.identifier)
    }
    
}
