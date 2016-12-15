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
    
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let note = note else {return}
        updateNote(note: note)
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        noteTitleTextField.resignFirstResponder()
        noteBodyTextView.resignFirstResponder()
    }
    
    
    //MARK: IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
    	note?.save()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Builder Functions
    func updateNote(note: Note?) {
        guard let title = note?.title else {return}
        guard let text = note?.text else {return}
        
        noteTitleTextField.text = title
        noteBodyTextView.text = text
    }

}

extension DetailNoteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
}

extension DetailNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTitleTextField.resignFirstResponder()
        
        return true
    }
    
}
