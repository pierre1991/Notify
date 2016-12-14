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
    
    fileprivate let kUser = "userKey"
    
    static let sharedController = UserController()

    
    
    var currentUser: User! {
        get {
            guard let uid = FIRAuth.auth()?.currentUser?.uid, let userDictionary = UserDefaults.standard.value(forKey: kUser) as? [String:AnyObject] else {return nil}
            
            return User(json: userDictionary, identifier: uid)
        } set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue.jsonValue, forKey: kUser)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: kUser)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    
    static func userForIdentifier(identifier: String, completion: @escaping (_ user: User?) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "users\(identifier)", completion: {(data) -> Void in
            if let json = data as? [String:AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user)
            } else {
                completion(nil)
            }
        })
    }
    
    
    static func createUser(email: String, password: String, imageEndpoint: String? = nil, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
       	FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                guard let identifier = user?.uid else {return}
                
                var user = User(email: email, imageEndpoint: imageEndpoint, identifier: identifier)
                user.save()
                
                authenticateUser(email: email, password: password, completion: { (success, user) in
                    completion(success, user)
                })
            } else {
                print("unable to create user")
                completion(false, nil)
            }
        })
    }
    
    
    static func authenticateUser(email: String, password: String, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard let user = user else { return }
            
            if error == nil {
                print("\(user.uid) signed in succesfully")
                
                UserController.userForIdentifier(identifier: user.uid, completion: { (user) in
                    if let user = user {
                        UserController.sharedController.currentUser = user
                    }
                  
                    completion(true, user)
                })
            } else {
                print("unalbe to sign in")
                completion(false, nil)
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
