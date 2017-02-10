//
//  ProfileViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/11/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    //MARK: Properties
    var newPicture: UIImage?
    let currentUser = UserController.sharedController.currentUser
    
    
    //MARK: Further UI
    lazy var backgroundBlur = UIVisualEffectView()
    let imagePicker = UIImagePickerController()
    
    
    //MARK: IBOutlets
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var profielImage: UIImageView!
    
	@IBOutlet weak var editPicureButton: UIButton!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var savePictureButton: UIButton!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savePictureButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, +self.view.frame.height, 0)
        
        imagePicker.delegate = self
        
        if let imageEndpoint = UserController.sharedController.currentUser.imageEndpoint {
            fetchUsersImage(imageEndpoint: imageEndpoint)
        }
        
        profileImageTap()
    }
    
    
    //MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: IBActions
    @IBAction func editPictureButtonTapped(_ sender: Any) {
    	photoAlert()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
        	try FIRAuth.auth()?.signOut()
        } catch {
            print("ERROR: Unable to sign user out")
        }
        
    	if let introViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
            present(introViewController, animated: true, completion: nil)
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        if newPicture != nil {
            savePictureAlert()
        } else {
        	dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func savePictureButtonTapped(_ sender: Any) {
        saveEditedImage()
        
        UIView.animate(withDuration: 0.4) { 
            self.savePictureButton.layer.transform = CATransform3DIdentity
        }
    }
    
    
    //MARK: Tap Gesture
    func profileImageTap() {
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(photoAlert))
        profielImage.isUserInteractionEnabled = true
        profielImage.addGestureRecognizer(profileImageTap)
    }

    
    //MARK: Builder Function
    func fetchUsersImage(imageEndpoint: String) {
        ImageController.imageForIdentifier(identifier: imageEndpoint) { (image) in
            guard let image = image else { return }
            
            self.profielImage.image = image
        }
    }
    
    func saveEditedImage() {
        guard let image = profielImage.image, let imageEndpoint = currentUser?.imageEndpoint else { return }
        
        ImageController.editImage(image: image, imageEndpoint: imageEndpoint)
        
        backgroundBlur.removeFromSuperview()
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                self.imagePicker.sourceType = .camera
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let newPicture = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        self.newPicture = newPicture
        profielImage.image = newPicture
        
        dismiss(animated: true) {
            self.savePictureAlert()
        }
    }
    
}

//MARK: View Functions
extension ProfileViewController {
    
    func createBlur() {
        let blur = UIBlurEffect(style: .dark)
        
        backgroundBlur.effect = blur
        backgroundBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundBlur.frame = self.view.bounds
        
        view.addSubview(backgroundBlur)
    }
    
    func savePictureAlert() {
        createBlur()
        
        view.bringSubview(toFront: savePictureButton)
        view.bringSubview(toFront: dismissButton)
        view.bringSubview(toFront: profielImage)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.savePictureButton.layer.transform = CATransform3DIdentity
        })
    }
    
}
