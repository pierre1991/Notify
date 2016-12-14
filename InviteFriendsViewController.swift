//
//  InviteFriendsViewController.swift
//  NotifyMe
//
//  Created by Pierre on 12/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import MessageUI

class InviteFriendsViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {


    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: Status Bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK: IBActions
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
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("NotifyMe")
            mailComposer.setMessageBody("Hey download this app so we can share notes!", isHTML: false)
            
            present(mailComposer, animated: true, completion: {
                UINavigationBar.appearance().barTintColor = UIColor.purpleThemeColor()
                UIBarButtonItem.appearance().tintColor = UIColor.white
            })
        }
    }
    
    
    //MARK: Mail Compose
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("message was cancelled")
        case .failed:
            print("message failed")
        case .sent:
            print("message was sent")
        case .saved:
            print("message was saved")
        }
        
        self.dismiss(animated: true, completion: nil)
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
    
}
