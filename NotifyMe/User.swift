//
//  User.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

struct User: Equatable, FirebaseType {
    
    private let kEmail = "email"
    private let kImageEndpoint = "imageEndpoint"
    private let kNoteId = "noteId"
    
    var email: String
    var imageEndpoint: String?
    var notes: [Note] = []
    var noteId: [String] = [] 
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
    init(email: String, imageEndpoint: String? = nil, identifier: String) {
        self.email = email
        self.imageEndpoint = imageEndpoint
        self.identifier = identifier
    }
    
    init?(json jsonValue: [String:AnyObject], identifier: String) {
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
    return (lhs.email == rhs.email) && (lhs.identifier == rhs.identifier)
}
