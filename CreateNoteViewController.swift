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
    //let currentUser: User?
    var allUsers: [User]?
    var selectedUsersForNote: [User] = []
    
    
    //MARK: IBOutlets
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var createNoteButton: UIButton!
    
    
	//MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()

        textFieldSetup()
        textViewSetup()
        
        getAllUsers { (users) in
            if let users = users {
                self.allUsers = users.filter({$0.identifier != UserController.sharedController.currentUser.identifier})
    
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
    @IBAction func rightBarActionButtonTapped(_ sender: Any) {
        if rightBarButton.image == #imageLiteral(resourceName: "more_button") {
            perform(#selector(reportUserAlertController))
        } else if rightBarButton.image == #imageLiteral(resourceName: "search_button") {
            print("searching for friends")
        }
    }
    
    
    @IBAction func createNoteButtonTapped(_ sender: Any) {
        guard let title = noteTitleTextField.text, let text = noteBodyTextView.text else { return }
        
        if selectedUsersForNote.isEmpty {
            let alertController = UIAlertController(title: "", message: "Don't forget to add users to your note", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "gotcha", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
            NoteController.createNote(title: title, text: text, identifier: UserController.sharedController.currentUser.identifier!, users: selectedUsersForNote) { (success, note) in
                if note != nil {
                    _ = navigationController?.popToRootViewController(animated: true)
                    self.selectedUsersForNote = (note?.users)!
                } else {
                    print("couldn't create note")
                }
            }
        }
    }
    
    
    //MARK: Builder Functions
    func getAllUsers(completion: @escaping (_ users: [User]?) -> Void) {
        UserController.fetchAllUsers { (users) in
            completion(users)
        }
    }
    
    //MARK: Report User Alert Controller
    func reportUserAlertController() {
        let reportActionSheet = UIAlertController(title: "Report", message: "", preferredStyle: .actionSheet)
        
		let reportAction = UIAlertAction(title: "Report Users", style: .default) { (alert) in
            for user in self.selectedUsersForNote {
                ReportController.reportUser(user)
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        reportActionSheet.addAction(reportAction)
        reportActionSheet.addAction(cancelAction)
        
        present(reportActionSheet, animated: true, completion: nil)
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
        
        cell?.contentView.backgroundColor = .purpleThemeColor()
        
        cell?.contentView.layer.cornerRadius = (cell?.frame.width)! / 2
        cell?.contentView.clipsToBounds = true
        
        if let users = allUsers {
            let user = users[indexPath.item]
            self.selectedUsersForNote.append(user)
            
            rightBarButton.image = #imageLiteral(resourceName: "more_button")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = nil
        
        self.selectedUsersForNote.removeLast()
        
        if self.selectedUsersForNote.isEmpty {
        	rightBarButton.image = #imageLiteral(resourceName: "search_button")
        }
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


//MARK: View Setup

extension CreateNoteViewController {
    
    func textFieldSetup() {
        noteTitleTextField.layer.borderWidth = 1
        noteTitleTextField.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
    func textViewSetup() {
        noteBodyTextView.layer.borderWidth = 1
        noteBodyTextView.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
}
