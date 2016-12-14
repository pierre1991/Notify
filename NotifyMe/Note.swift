//
//  Note.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

struct Note: FirebaseType {
    
    private let kTitle = "title"
    private let kText = "text"
    private let kUids = "userIds"
    
    var title: String
    var text: String = ""
    var users: [User] = []
    var identifier: String?
    var userIds: [String] = []
    var endpoint: String {
        return "notes"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kTitle : title as AnyObject, kText : text as AnyObject, kUids : users.map({$0.identifier}) as AnyObject]
    }
    
    
    init(title: String, text: String, identifier: String? = nil, users: [User]) {
        self.title = title
        self.text = text
        self.users = users
    }
    
    init?(json jsonValue: [String:AnyObject], identifier: String) {
        guard let title = jsonValue[kTitle] as? String, let text = jsonValue[kText] as? String else { return nil }
        
        self.title = title
        self.text = text
        self.identifier = identifier
        
        if let userIds = jsonValue[kUids] as? [String] {
            self.userIds = userIds
        }
    }
    
    
}
