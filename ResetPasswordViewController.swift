//
//  ResetPasswordViewController.swift
//  NotifyMe
//
//  Created by Pierre on 1/24/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    //MARK: Properties
    var keyboardHeight: CGFloat!
    
    
    //MARK: IBOutlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResetPasswordButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
    }
    
    
	//MARK: IBActions
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {
            emailTextField.shake()
        	return
        }
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                print("error resetting email")
            } else {
                print("password reset sent")
                
                self.dismiss(animated: true, completion: nil)
            }
        })
	}
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        resignFirstResponder()
        
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
        	UIView.animate(withDuration: 0.8, animations: {
                self.emailTextField.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, (self.descriptionLabel.frame.minY - self.keyboardHeight), 0)
                self.resetPasswordButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, (self.descriptionLabel.frame.minY - self.keyboardHeight), 0)
                self.cancelButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, (self.descriptionLabel.frame.minY - self.keyboardHeight), 0)
            })
        } else {
            UIView.animate(withDuration: 0.8, animations: { 
                self.emailTextField.layer.transform = CATransform3DIdentity
                self.resetPasswordButton.layer.transform = CATransform3DIdentity
                self.cancelButton.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    
    //MARK: View Function
    func setupResetPasswordButton() {
        resetPasswordButton.layer.cornerRadius = 2.0
        resetPasswordButton.layer.borderColor = UIColor.white.cgColor
        resetPasswordButton.layer.borderWidth = 1.0
        
        resetPasswordButton.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
    }

}


extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        
        return true
    }
}
