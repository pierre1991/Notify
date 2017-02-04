//
//  NoteTableViewCell.swift
//  NotifyMe
//
//  Created by Pierre on 11/29/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

protocol UserNotes: class {
    func fetchNotes() -> [Note]?
}

class NoteTableViewCell: UITableViewCell {
	
    //MARK: Properties
    //var userImageEndpoint: [String]?
    
    
    var userIdentifirs: [User]?
    var userNotes: [Note]?
    
    weak var fetchNotesDelegate: UserNotes?
    
    
    //MARK: IBOulets
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNotes = fetchNotesDelegate?.fetchNotes()
        
        /*
        for identifiers in userNotes! {
            userIdentifirs?.append(contentsOf: identifiers.users)
        }
        
        for imageEndpoint in userIdentifirs! {
            userImageEndpoint?.append(imageEndpoint.imageEndpoint!)
            
        }
 		*/
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateNote(note: Note) {
        noteTitleLabel.text = note.title
        noteBodyLabel.text = note.text
    }

}

extension NoteTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     	return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImage", for: indexPath) as! UserCollectionViewCell
        
        cell.backgroundColor = .blue
        
    	return cell
    }
    
    
    /*
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }
 	*/
}
