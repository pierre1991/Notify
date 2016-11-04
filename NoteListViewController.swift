//
//  NoteListViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Firebase

class NoteListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        if let user = FIRAuth.auth()?.currentUser {
            print("\(user) signed in")
        } else {
            performSegue(withIdentifier: "toSignupLoginView", sender: self)
        }
    }
}
