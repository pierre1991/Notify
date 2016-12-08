//
//  CreateNoteViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Firebase

class CreateNoteViewController: UIViewController {
    
    //MARK: Properties
    let currentUser = FIRAuth.auth()?.currentUser
    var allUsers: [User]?
    var selectedUsersForNote: [User] = []
    
    
    //MARK: IBOutlets
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var createNoteButton: UIButton!
    
    
	//MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.fetchAllUsers { (user) in
            guard let user = user else {return}
            
            self.allUsers = user.filter({$0.identifier != UserController.sharedController.currentUser.identifier})
            
            DispatchQueue.main.async {
				self.userCollectionView.reloadData()
            }
        }
    }
    
    
    //MARK: IBActions
    @IBAction func createNoteButtonTapped(_ sender: Any) {
        guard let navigationController = navigationController else {return}
        navigationController.popToRootViewController(animated: true)
	}

}

extension CreateNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allUsers = allUsers {
            return allUsers.count
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImage", for: indexPath) as! UserCollectionViewCell
        
        if let users = allUsers {
            let user = users[indexPath.item]
            let userImage = user.imageEndpoint
            
            if let identifier = userImage {
            	cell.updateUserImage(identifier: identifier)
            }
        }
        
    	return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .blue
        
        if let users = allUsers {
            let user = users[indexPath.item]
            self.selectedUsersForNote.append(user)
        }
    }
    
}


extension CreateNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTitleTextField.resignFirstResponder()
        
        return true
    }
    
}
