//
//  ImageUploader.swift
//  NotifyMe
//
//  Created by Pierre on 11/4/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ImageController {
    
	static func uploadImage(image: UIImage, completion:(_ identifier: String?) -> Void) {
        if let base64image = image.base64String {
            let base = FirebaseController.base.child("image").childByAutoId()
            
            base.setValue(base64image)
            
            completion(base.key)
        } else {
            completion(nil)
        }
    }
    
    static func imageForIdentifier(identifier: String, completion:@escaping (_ image: UIImage?) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "image/\(identifier)") { (data) -> Void in
            if let data = data as? String {
                let image = UIImage(base64: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}

extension UIImage {
    
    var base64String: String? {
        guard let data = UIImageJPEGRepresentation(self, 0.8) else {
            return nil
        }
        
        return data.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    convenience init?(base64: String) {
        if let imageData = NSData(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            self.init(data: imageData as Data)
        } else {
            return nil
        }
    }
}
