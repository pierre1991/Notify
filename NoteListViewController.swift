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

    //MARK: Properties
    var notes: [Note] = []
    
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
	
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentUser = UserController.sharedController.currentUser {
        	loadNotesForUser(user: currentUser)
        } else {
            performSegue(withIdentifier: "toSignupLoginView", sender: self)
        }
    }
    
    
    //MARK: Builder Functions
    func loadNotesForUser(user: User) {
        NoteController.fetchNotesForUser(user: user, completion: { (notes) -> Void in
            if let notes = notes {
                self.notes = notes
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("no notes to display")
            }
        })
    }
    
}


extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
