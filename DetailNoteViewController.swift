//
//  DetailNoteViewController.swift
//  NotifyMe
//
//  Created by Pierre on 12/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class DetailNoteViewController: UIViewController {

    
    //MARK: Properties
    var note: Note?
    var usersOfNote: [User]?
    
    let collectionViewCellSize: CGFloat = 66.0
    
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldSetup()
        textViewSetup()
        
        guard let note = note else {return}
        updateNote(note: note)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUsersOfNote()
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        noteTitleTextField.resignFirstResponder()
        noteBodyTextView.resignFirstResponder()
    }
    
    
    //MARK: IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
    	NoteController.saveNote(note: note!)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Builder Functions
    func updateNote(note: Note?) {
        guard let title = note?.title else {return}
        guard let text = note?.text else {return}
        
        noteTitleTextField.text = title
        noteBodyTextView.text = text
    }
    
    func getUsersOfNote() {
        guard let note = note else { return }
        
        NoteController.fetchUsersForNote(note: note) { (users) in
            if let users = users {
                self.usersOfNote = users
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

extension DetailNoteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let usersOfNote = usersOfNote else {return 0}
        
        return usersOfNote.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImage", for: indexPath) as! UserCollectionViewCell
        
        if let usersOfNote = usersOfNote {
            let user = usersOfNote[indexPath.item]
            let userImage = user.imageEndpoint
            
            if let identifier = userImage {
                cell.updateUserImage(identifier: identifier)
            }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.frame.size.width - collectionViewCellSize) / 2
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
}


extension DetailNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTitleTextField.resignFirstResponder()
        
        return true
    }
    
}


//MARK: View Setup
extension DetailNoteViewController {
    
    func textFieldSetup() {
        noteTitleTextField.layer.borderWidth = 1
        noteTitleTextField.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
    func textViewSetup() {
        noteBodyTextView.layer.borderWidth = 1
        noteBodyTextView.layer.borderColor = UIColor.purpleThemeColor().cgColor
    }
    
}
