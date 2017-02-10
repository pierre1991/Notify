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
            guard let uid = FIRAuth.auth()?.currentUser?.uid, let userDictionary = UserDefaults.standard.value(forKey: kUser) as? [String:AnyObject] else { return nil }
            
            return User(jsonValue: userDictionary, identifier: uid)
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
    
    
    // Create User
    static func createUser(username: String, email: String, password: String, imageEndpoint: String, completionHandler: @escaping (_ success: Bool, _ user: User?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) -> Void in
            if error == nil {
                guard let identifier = user?.uid else { return }
                
                var user = User(identifier: identifier, username: username, email: email, imageEndpoint: imageEndpoint)
                user.save()
                
                authenticateUser(username: username,email: email, password: password, completionHandler: { (success, user) in
                    completionHandler(true, user)
                })
            } else {
                print("unable to create user")
                completionHandler(false, nil)
        	}
        })
    }
    
    
    // Authenticate User
    static func authenticateUser(username: String, email: String, password: String, completionHandler: @escaping (_ success: Bool, _ user: User?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) -> Void in
            if error != nil {
                print("Unsuccessful login attempt.")
                
                completionHandler(false, nil)
            } else {
                guard let user = user else { return }
                
                print("User ID: \(user.uid) authenticated successfully.")
                
                UserController.userForIdentifier(identifier: user.uid, completionHandler: { (user) -> Void in
                    if let user = user {
                        sharedController.currentUser = user
                    }
                    
                    completionHandler(true, user)
                })
            }
        })
    }
    
    
    // Update User Image
//    static func updateUsersImage(identifier: String, image: UIImage, completion: (_ identifier: String?) -> Void) {
//        FirebaseController.dataAtEndpoint(endpoint: "image/\(identifier)") { (data) in
//            if let data = data as? String {
//                
//            }
//        }
//    }
    
    
    // Return User from Identifier
    static func userForIdentifier(identifier: String, completionHandler: @escaping (_ user: User?) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "users/\(identifier)", completion: {(data) -> Void in
            if let json = data as? [String: AnyObject] {
                let user = User(jsonValue: json, identifier: identifier)
                
                completionHandler(user)
            } else {
                completionHandler(nil)
            }
        })
    }
    
    
    // Get all Users of App
    static func fetchAllUsers(completionHandler: @escaping (_ user: [User]) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "users") { (data) in
            if let data = data as? [String:AnyObject] {
                let users = data.flatMap({User(jsonValue: $0.1 as! [String: AnyObject], identifier: $0.0)})
                completionHandler(users)
            } else {
                completionHandler([])
            }
        }
    }

    

}
