//
//  LoginSignupViewController.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import AVFoundation

class LoginSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
	//MARK: Properties
    var profileImage: UIImage?
    
    var keyboardHeight: CGFloat!
    
    var signupStateShowing = true
    var loginStateShowing = false
    
    
    //MARK: IBOutlets
    @IBOutlet weak var notifyMeLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var accountActionLabel: UILabel!
    @IBOutlet weak var accountActionButton: UIButton!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        //moveOutLoginViews()
        
        profileImageTap()
    }
    
    
    //MARK: Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        signUpEmailTextField.resignFirstResponder()
        signUpPasswordTextField.resignFirstResponder()
    }
    
    
    //MARK: IBActions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if signUpButton.currentTitle == "Sign up!" {
            guard let profileImage = profileImage, let email = signUpEmailTextField.text, isValidEmail(email: email), let password = signUpPasswordTextField.text else {
                profileImageView.shake()
                signUpEmailTextField.shake()
                signUpPasswordTextField.shake()
                
                return
            }
            
            ImageController.uploadImage(image: profileImage, completion: { (identifier) in
                guard let identifier = identifier else { return }
                    
                UserController.createUser(email: email, password: password, imageEndpoint: identifier, completion: { (success, user) in
                    if success, let _ = user {
                        self.signUpEmailTextField.resignFirstResponder()
                        self.signUpPasswordTextField.resignFirstResponder()
                        
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.presentMessageViewController(title: "Oops", message: "something went wrong")
                    }
                })
            })
        } else if signUpButton.currentTitle == "Log in!" {
            guard let email = signUpEmailTextField.text, isValidEmail(email: email), let password = signUpPasswordTextField.text else {
                signUpEmailTextField.shake()
                signUpPasswordTextField.shake()
                
                return
            }
            
            UserController.authenticateUser(email: email, password: password, completion: { (true, user) in
                if true, (user != nil) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.presentMessageViewController(title: "Something went wrong", message: "Please check your email and password and try again")
                }
            })
        }
    }
    
    
    @IBAction func accountActionButtonTapped(_ sender: Any) {
        if accountActionButton.currentTitle == "Log in!" {
            signUpEmailTextField.text = ""
            signUpPasswordTextField.text = ""
            
			signupStateShowing = false
            loginStateShowing = true
            
            alreadyHaveAccountDescription()
            
            UIView.animate(withDuration: 0.6, animations: { 
                self.profileImageView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.view.frame.width, 0, 0)
                self.signUpButton.alpha = 0
			}, completion: { (finished) in
    			self.signUpButton.setTitle("Log in!", for: .normal)
                
                UIView.animate(withDuration: 0.6, animations: { 
                    self.signUpButton.alpha = 1
                })
            })
        } else if accountActionButton.currentTitle == "Sign up!" {
            signUpEmailTextField.text = ""
            signUpPasswordTextField.text = ""
            
    		signupStateShowing = true
            loginStateShowing = false
            
            needAnAccountDescription()
            
            UIView.animate(withDuration: 0.6, animations: {
                self.profileImageView.layer.transform = CATransform3DIdentity
                self.signUpButton.alpha = 0
            }, completion: { (finished) in
                self.signUpButton.setTitle("Sign up!", for: .normal)
                
                UIView.animate(withDuration: 0.6, animations: {
                    self.signUpButton.alpha = 1
                })
            })
            
            moveInSignupViews()
        }
    }
    
    

    //MARK: Helper Functions
    func moveInSignupViews() {
        UIView.animate(withDuration: 0.6, animations: {
            self.profileImageView.layer.transform = CATransform3DIdentity
            self.signUpEmailTextField.layer.transform = CATransform3DIdentity
            self.signUpPasswordTextField.layer.transform = CATransform3DIdentity
            self.signUpButton.layer.transform = CATransform3DIdentity
        })
    }
    
    func moveOutSignupViews() {
        UIView.animate(withDuration: 0.6, animations: {
            self.profileImageView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.view.frame.width, 0, 0)
            self.signUpEmailTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.view.frame.width, 0, 0)
            self.signUpPasswordTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.view.frame.width, 0, 0)
            self.signUpButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.view.frame.width, 0, 0)
        })
    }

    
    func alreadyHaveAccountDescription() {
        UIView.animate(withDuration: 0.6, animations: {
            self.accountActionLabel.alpha = 0
            self.accountActionButton.alpha = 0
        }, completion: {(finish) in
            self.accountActionLabel.text = "Need an account?"
            self.accountActionButton.setTitle("Sign up!", for: .normal)
            
            UIView.animate(withDuration: 0.6, animations: {
                self.accountActionLabel.alpha = 1
                self.accountActionButton.alpha = 1
            })
        })
    }
    
    func needAnAccountDescription() {
        UIView.animate(withDuration: 0.6, animations: {
			self.accountActionLabel.alpha = 0
            self.accountActionButton.alpha = 0
        }, completion: {(finish) in
            self.accountActionLabel.text = "Already have an account?"
            self.accountActionButton.setTitle("Log in!", for: .normal)

            UIView.animate(withDuration: 0.6, animations: {
                self.accountActionLabel.alpha = 1
                self.accountActionButton.alpha = 1
            })
        })
    }
    
    
    //MARK: Alert View Contorller 
    func presentMessageViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Tap Gesture 
    func profileImageTap() {
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
    	profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTap)
    }
    
    func profileImageTapped() {
        handleCameraPermissions()

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
    func handleCameraPermissions() {
        let mediaType = AVMediaTypeVideo
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        
        switch authStatus {
        case .authorized:
            print("you have authorized AV")
            return
        case .denied:
            print("you have denied AV")
            
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        case .notDetermined:
            print("you have not determined AV")
        case .restricted:
            print("you have restricted AV")
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
    	profileImage = originalImage
        
        profileImageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Keyboard
    func keyboardNotification(_ notification: Notification) {
        let info: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame: CGRect = value.cgRectValue
        let cgFloatKeyboardHeight: CGFloat = keyboardFrame.size.height
        
        self.keyboardHeight = cgFloatKeyboardHeight
        
        let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        
        if isKeyboardShowing {
            if signupStateShowing == true {
                UIView.animate(withDuration: 0.8, animations: {
                    self.notifyMeLabel.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -self.view.bounds.height, 0)
                })
                
                UIView.animate(withDuration: 0.8, animations: {
                    //self.notifyMeLabel.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -self.view.frame.height, 0)
                    self.profileImageView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 4) - (self.profileImageView.frame.height / 2), 0)
                    self.signUpEmailTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpEmailTextField.frame.height / 2), 0)
                    self.signUpPasswordTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpPasswordTextField.frame.height / 2), 0)
                    self.signUpButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpButton.frame.height / 2), 0)
                })
            } else if loginStateShowing == true {
                UIView.animate(withDuration: 0.8, animations: {
                    self.signUpEmailTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpEmailTextField.frame.height / 2), 0)
                    self.signUpPasswordTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpPasswordTextField.frame.height / 2), 0)
                    self.signUpButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -((UIScreen.main.bounds.height - self.keyboardHeight) / 3) - (self.signUpButton.frame.height / 2), 0)
                })
            }
        } else {
            if signupStateShowing == true {
                UIView.animate(withDuration: 0.8, animations: {
                    self.notifyMeLabel.layer.transform = CATransform3DIdentity
                })
                
                self.profileImageView.layer.transform = CATransform3DIdentity
                self.signUpEmailTextField.layer.transform = CATransform3DIdentity
                self.signUpPasswordTextField.layer.transform = CATransform3DIdentity
                self.signUpButton.layer.transform = CATransform3DIdentity
            } else if loginStateShowing == true {
                UIView.animate(withDuration: 0.8, animations: {
                    self.signUpEmailTextField.layer.transform = CATransform3DIdentity
                    self.signUpPasswordTextField.layer.transform = CATransform3DIdentity
                    self.signUpButton.layer.transform = CATransform3DIdentity
                })
            }
        }
    }

    
    //MARK: TextField
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpEmailTextField.resignFirstResponder()
        signUpPasswordTextField.resignFirstResponder()

        return true
    }
    
    
    
    //MARK: Email Validity
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
 	
    
}
