//
//  Note.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class Note: FirebaseType {
    
    private let kTitle = "title"
    private let kText = "text"
    private let kUID = "userIds"

    var title: String
    var text: String
    var users: [User] = []
    var userIds: [String] = []
    
    var identifier: String?
    var endpoint: String {
        return "notes"
    }
    var jsonValue: [String: AnyObject] {
    	return [kTitle: title as AnyObject, kText: text as AnyObject, kUID: users.map{$0.identifier} as AnyObject]
    }
    
    // Init
    init(title: String, text: String, users: [User]) {
        self.title = title
        self.text = text
        self.users = users
    }
    
    required init?(jsonValue: [String: AnyObject], identifier: String) {
        guard let title = jsonValue[kTitle] as? String, let text = jsonValue[kText] as? String else {
            self.title = ""
            self.text = ""
            
            return nil
        }
        
        self.title = title
        self.text = text
        self.identifier = identifier
        
        if let userIds = jsonValue[kUID] as? [String] {
            self.userIds = userIds
        }
    }
}
