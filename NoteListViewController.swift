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

    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		checkForCurrentuser()
    }
    
    
    //MARK: IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        
        checkForCurrentuser()
    }
    
    
    //MARK: Helper Functions
    func checkForCurrentuser() {
        if let user = FIRAuth.auth()?.currentUser {
            print("\(user) signed in")
        } else {
            performSegue(withIdentifier: "toSignupLoginView", sender: self)
        }
    }
}
