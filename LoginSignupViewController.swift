//
//  LoginSignupViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    //MARK: Properties
    var profileImage: UIImage?
    
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    
	@IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageTap()
    }
    
    
    //MARK: IBActions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = signUpEmailTextField.text, let password = signUpPasswordTextField.text else {return}
        
        if let profileImage = profileImage {
            ImageController.uploadImage(image: profileImage, completion: { (identifier) in
                guard let identifier = identifier else {return}
                
                UserController.createUser(email: email, password: password, imageEndpoint: identifier, completion: { (success, user) in
                    if success, let _ = user {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.presentMessageViewController(title: "Oops", message: "something went wrong")
                    }
                })
            })
        } else {
            presentMessageViewController(title: "OOOOOPS", message: "OOOOOPS")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
    
    

    

    
    
    //MARK: Alert View Contorller 
    func presentMessageViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        signUpEmailTextField.resignFirstResponder()
        signUpPasswordTextField.resignFirstResponder()
    }
    
    
    //MARK: Tap Gesture 
    func profileImageTap() {
    	let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
    	profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTap)
    }
    
    func profileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) -> Void in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) -> Void in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
    	profileImage = originalImage
        
        profileImageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpEmailTextField.resignFirstResponder()
        signUpPasswordTextField.resignFirstResponder()
        
        return true
    }
    
    
}


