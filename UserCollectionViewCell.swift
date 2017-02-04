//
//  UserCollectionViewCell.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var userProfileImage: CircularImageView!
    
    
    //MARK: Builder Function
    func updateUserImage(identifier: String?) {
        guard let identifier = identifier else { return }
        
        ImageController.imageForIdentifier(identifier: identifier, completionHandler: {(image) -> Void in
            guard let image = image else {return}
            
            self.userProfileImage.image = image
        })
    }
    
}

