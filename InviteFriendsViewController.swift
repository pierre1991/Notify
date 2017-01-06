//
//  InviteFriendsViewController.swift
//  NotifyMe
//
//  Created by Pierre on 12/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import MessageUI


class InviteFriendsViewController: UIViewController, FBSDKAppInviteDialogDelegate, MFMessageComposeViewControllerDelegate {


    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: Status Bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK: IBActions
    @IBAction func dismissViewButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let content = FBSDKAppInviteContent()
        
        content.appLinkURL = URL(string: "")
        
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposer = MFMessageComposeViewController()
            
            messageComposer.messageComposeDelegate = self
            messageComposer.body = "Hey download this app so we can share notes!"
            
            present(messageComposer, animated: true, completion: {
                UINavigationBar.appearance().barTintColor = UIColor.purpleThemeColor()
                UIBarButtonItem.appearance().tintColor = UIColor.white
            })
        }
    }
    

    
    //MARK: Message Compose
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("message was cancelled")
        case .failed:
            print("message failed")
        case .sent:
            print("message was sent")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: FBSDKAppInviteDialogDelegate Functions
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("App Invite Successful")
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("App Invite Failed")
    }
    
}
