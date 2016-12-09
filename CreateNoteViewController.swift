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
        
        setupCollectionView()
        
        getAllUsers { (users) in
            if let users = users {
                self.allUsers = users.filter({$0.identifier != FIRAuth.auth()?.currentUser?.uid})
    
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
            } else {
                self.allUsers = []
            }
        }
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        noteTitleTextField.resignFirstResponder()
        noteBodyTextView.resignFirstResponder()
    }
    
    
    //MARK: IBActions
    @IBAction func createNoteButtonTapped(_ sender: Any) {
        guard let title = noteTitleTextField.text, let body = noteBodyTextView.text else {return}
        
        NoteController.createNote(title: title, text: body, identifier: (FIRAuth.auth()?.currentUser?.uid)!, users: selectedUsersForNote, completion: { (success, note) -> Void in
            if note != nil {
                guard let navigationController = navigationController else {return}
                navigationController.popToRootViewController(animated: true)
                
                self.selectedUsersForNote = (note?.users)!
            } else {
                //TODO: present user with alert
                
                print("unable to create note")
            }
        })
    }
    
    
    func getAllUsers(completion: @escaping (_ users: [User]?) -> Void) {
        UserController.fetchAllUsers { (users) in
            completion(users)
        }
    }

}

extension CreateNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allUsers = allUsers {
            return allUsers.count
        } else {
            return 0
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = nil
        
        self.selectedUsersForNote.removeLast()
    }
    
    func setupCollectionView() {
        userCollectionView.allowsMultipleSelection = true
        
        
    }
    
}


extension CreateNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTitleTextField.resignFirstResponder()
        
        return true
    }
    
}
