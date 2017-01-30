//
//  User.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import Firebase

class User: FirebaseType {
    
    private let kUsername = "username"
    private let kEmail = "email"
    private let kImageEndpoint = "imageEndpoint"
    private let kNoteId = "noteId"
    
    var username: String
    var email: String
    var imageEndpoint: String?
    var notes: [Note] = []
    var noteId: [String] = [] {
        didSet {
            if identifier == UserController.sharedController.currentUser.identifier {
                UserDefaults.standard.set(self.jsonValue, forKey: "userKey")
            }
        }
    }
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kUsername: username as AnyObject, kEmail: email as AnyObject, kNoteId: noteId as AnyObject]
        
        if let imageEndpoint = imageEndpoint {
            json.updateValue(imageEndpoint as AnyObject, forKey: kImageEndpoint)
        }
        
        return json
    }
    
    //Init
    init(username: String, email: String, imageEndpoint: String? = nil, identifier: String) {
        self.username = username
        self.email = email
        self.imageEndpoint = imageEndpoint
        self.identifier = identifier
    }
    
    required init?(jsonValue: [String: AnyObject], identifier: String) {
        guard let username = jsonValue[kUsername] as? String, let email = jsonValue[kEmail] as? String, let imageEndpoint = jsonValue[kImageEndpoint] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.imageEndpoint = imageEndpoint
        self.identifier = identifier
        
        if let noteId = jsonValue[kNoteId] as? [String] {
            self.noteId = noteId
        }
    }
    
}

