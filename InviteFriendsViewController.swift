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
