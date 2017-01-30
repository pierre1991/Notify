//
//  FirebaseController.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let base = FIRDatabase.database().reference()
    
    static func dataAtEndpoint(endpoint: String, completion: @escaping (_ data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.child(endpoint)
        
       	baseForEndpoint.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.value is NSNull {
                completion(nil)
            } else {
                completion(snapshot.value as AnyObject?)
            }
        })
    }
}

protocol FirebaseType {
    // Identifier will be an optional string (assigned when object is created in firebase .childByAutoID())
    var identifier: String? { get set }
    
    // Endpoint is a required string used to define the path that must be traversed in firebase for access
    var endpoint: String { get }

    // JSON Value is a computed dictionary that will be used to store the various attributes of model objects in firebase
    var jsonValue: [String: AnyObject] { get }
    
    // Failable initializer that utilizes a JSON formatted dictionary to initialize a partiular model object. Requires identifier for initialization
    init?(jsonValue: [String: AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}


extension FirebaseType {
    
    // All objects conforming to FirebaseType will implement the following save function. This implementation checks for an identifier, if identifier is present the identifier is passed into childByAppendingPath. If not, a new ID is generated. The Firebase location is then updated with the jsonValue of the respective path
    mutating func save() {
        var endpointBase: FIRDatabaseReference
        
        if let identifier = identifier {
            endpointBase = FirebaseController.base.child(endpoint).child(identifier)
        } else {
            endpointBase = FirebaseController.base.child(endpoint).childByAutoId()
            self.identifier = endpointBase.key
        }
        
        endpointBase.updateChildValues(self.jsonValue)
    }
    
    // Uses endpoint and identifier to construct a path and remove jsonValue at the path's value
    func delete() {
        if let identifier = self.identifier {
            let endpointBase = FIRDatabase.database().reference().child(endpoint).child(identifier)
            
            endpointBase.removeValue()
        }
    }
}

