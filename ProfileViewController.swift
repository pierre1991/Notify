//
//  ProfileViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/11/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    //MARK: IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
