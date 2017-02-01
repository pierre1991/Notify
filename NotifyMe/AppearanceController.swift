//
//  AppearanceController.swift
//  NotifyMe
//
//  Created by Pierre on 11/29/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit

class AppearanceController {
    
    static func initializeAppearance() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .purpleThemeColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        //UITextField.appearance().keyboardAppearance = .dark
        
        //UITextView.appearance().keyboardAppearance = .dark
        
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightThin)
        ]
    }
    
}
