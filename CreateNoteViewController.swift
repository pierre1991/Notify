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
    var allUsers: [User]?
    var selectedUsersForNote: [User] = []
    
    
    //MARK: Further UI
    var collectionViewCellSize: CGFloat = 80.0
    
    
    //MARK: IBOutlets
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var createNoteButton: UIButton!
    
    
	//MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldSetup()
        textViewSetup()
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

extension CreateNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsersForNote.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImage", for: indexPath) as! UserCollectionViewCell
        
        let usersOfNote = selectedUsersForNote[indexPath.item]
        let userImage = usersOfNote.imageEndpoint
        
        if let identifier = userImage {
            cell.updateUserImage(identifier: identifier)
        }
        
    	return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noteTitleTextField.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.frame.size.width - collectionViewCellSize) / 2
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
}


extension CreateNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTitleTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldSetup() {
        noteTitleTextField.layer.borderWidth = 1
        noteTitleTextField.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
    func textViewSetup() {
        noteBodyTextView.layer.borderWidth = 1
        noteBodyTextView.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
}

