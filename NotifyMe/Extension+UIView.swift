//
//  Extension+UIView.swift
//  NotifyMe
//
//  Created by Pierre on 1/10/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }

}
