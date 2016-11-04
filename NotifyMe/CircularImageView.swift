//
//  CircularImageView.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupImage()
    }
    
    override func awakeFromNib() {
        setupImage()
    }
    
    
    func setupImage() {
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
    }
    
}
