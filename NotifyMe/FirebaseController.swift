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
    
    var identifier: String? {get set}
    var endpoint: String {get}
    var jsonValue: [String : AnyObject] {get}
    
    init?(json: [String : AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}


extension FirebaseType {
    
    mutating func save() {
        var endpointBase: FIRDatabaseReference
        
        if let identifier = identifier {
            endpointBase = FIRDatabase.database().reference().child(endpoint).child(identifier)
        } else {
            endpointBase = FIRDatabase.database().reference().child(endpoint).childByAutoId()
            self.identifier = endpointBase.key
        }
        
        endpointBase.updateChildValues(self.jsonValue)
    }
    
    func delete() {
        if let identifier = self.identifier {
            let endpointBase = FIRDatabase.database().reference().child(endpoint).child(identifier)
            
            endpointBase.removeValue()
        }
    }
}

