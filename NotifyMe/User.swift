//
//  User.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class User: FirebaseType, Equatable {
    
    private let kEmail = "email"
    private let kImageEndpoint = "imageEndpoint"
    private let kNoteId = "noteId"
    
    var username: String
    var email: String
    var imageEndpoint: String?
    var notes: [Note] = []
    var noteId: [String] = [] {
        didSet {
            
        }
    }
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String : AnyObject] {
        var json: [String : AnyObject] = [kEmail:email as AnyObject, kNoteId:noteId as AnyObject]
        
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
    
    required init?(json: [String:AnyObject], identifier: String) {
        guard let email = jsonValue[kEmail] as? String else {return nil}
        guard let imageEndpoint = jsonValue[kImageEndpoint] as? String else {return nil}
        guard let noteId = jsonValue[kNoteId] as? [String] else {return nil}
        
        self.email = email
        self.imageEndpoint = imageEndpoint
        self.noteId = noteId
        self.identifier = identifier
    }
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.username == rhs.username && lhs.identifier == rhs.identifier
}
