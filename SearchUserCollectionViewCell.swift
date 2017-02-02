//
//  SearchUserCollectionViewCell.swift
//  NotifyMe
//
//  Created by Pierre on 1/30/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import UIKit

class SearchUserCollectionViewCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var userProfileImage: CircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundHighlightView: CircularView!
    
    
    //MARK: Builder Functions
    func updateUser(user: User) {
        usernameLabel.text = user.username
        
        guard let identifier = user.imageEndpoint else { return }
        
        ImageController.imageForIdentifier(identifier: identifier) { (image) in
            guard let image = image else { return }
            
            self.userProfileImage.image = image
        }
    }
    
}
