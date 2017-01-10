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
    
    var storedOffsets = [Int: CGFloat]()
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noNotesView: UIView!
	
    @IBOutlet weak var profileImage: CircularImageView!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    	tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentUser = UserController.sharedController.currentUser {
        	loadNotesForUser(user: currentUser)
        } else {
            performSegue(withIdentifier: "toSignupLoginView", sender: self)
		}
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? DetailNoteViewController
        
        if segue.identifier == "toNoteDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let note = self.notes[indexPath.row]
            destinationViewController?.note = note
        }
    }

    
    //MARK: Builder Functions
    func loadNotesForUser(user: User) {
        NoteController.fetchNotesForUser(user, completion: { (notes) -> Void in
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
        if notes.count == 0 {
            noNotesView.isHidden = false
        } else if notes.count > 0 {
            noNotesView.isHidden = true
        }
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        
        cell.updateNote(note: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? NoteTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? NoteTableViewCell else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
}


extension NoteListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImage", for: indexPath) as! UserCollectionViewCell
        
        return cell
    }
    
    
    
}
