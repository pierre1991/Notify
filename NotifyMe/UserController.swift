//
//  UserController.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let sharedController = UserController()
    
    static func createUser(email: String, password: String, imageEndpoint: String? = nil, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                guard let identifier = user?.uid else {return}
                
                var user = User(email: email, imageEndpoint: imageEndpoint, identifier: identifier)
                
                
                
                
            } else {
                print("unable to create user")
                completion(false, nil)
            }
        })
    }
    
    
    
    static func fetchAllUsers(completion: @escaping (_ user: [User]) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "users") { (data) in
            if let json = data as? [String:AnyObject] {
                let users = json.flatMap({User(jsonValue: $0.1 as! [String:AnyObject], identifier: $0.0)})
                completion(users)
            } else {
                completion([])
            }
        }
    }
    

    
    
    
}
