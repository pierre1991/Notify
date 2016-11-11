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

    static let currentUser = FIRAuth.auth()?.currentUser?.uid
    
    
    static func createUser(email: String, password: String, imageEndpoint: String? = nil, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                guard let identifier = user?.uid else {return}
                
                var user = User(email: email, imageEndpoint: imageEndpoint, identifier: identifier)
                user.save()
                
                completion(true, user)
            } else {
                print("unable to create user")
                completion(false, nil)
            }
        })
    }
    
    
    static func authenticateUser(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                completion(true)
            } else {
                print("unalbe to sign in")
                completion(false)
            }
        })
    }
    
    
    static func fetchAllUsers(completion: @escaping (_ user: [User]) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "users") { (data) in
            if let data = data as? [String:AnyObject] {
                let users = data.flatMap({User(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                completion(users)
            } else {
                completion([])
            }
        }
    }
    
    
}
