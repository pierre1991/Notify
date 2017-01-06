//
//  ProfileViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/11/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    let imagePicker = UIImagePickerController()
    
    
    
    //MARK: IBOutlets
    @IBOutlet weak var profielImage: UIImageView!
    
	@IBOutlet weak var editPicureButton: UIButton!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let imageEndpoint = UserController.sharedController.currentUser.imageEndpoint {
            fetchUsersImage(imageEndpoint: imageEndpoint)
        }
        
        profileImageTap()
    }

    func fetchUsersImage(imageEndpoint: String) {
        ImageController.imageForIdentifier(identifier: imageEndpoint) { (image) in
            guard let image = image else { return }
            
            self.profielImage.image = image
        }
    }

    
    //MARK: IBActions
    @IBAction func editPictureButtonTapped(_ sender: Any) {
    	photoAlert()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Tap Gesture
    func profileImageTap() {
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(photoAlert))
        profielImage.isUserInteractionEnabled = true
        profielImage.addGestureRecognizer(profileImageTap)
    }
    
	
    func photoAlert() {
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.imagePicker.sourceType = .photoLibrary
                
                self.present(self.imagePicker, animated: true, completion: nil)
        	}))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.imagePicker.sourceType = .photoLibrary
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profielImage.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    


}
