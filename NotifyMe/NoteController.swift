//
//  NoteController.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class NoteController {
    
    static let sharedController = NoteController()
    
    static func createNote(title: String, text: String?, identifier: String, users: [User], completion: (_ success: Bool, _ note: Note?) -> Void) {
        if let text = text {
            var note = Note(title: title, text: text, identifier: UserController.currentUser, users: users)
            note.save()
            
            guard let noteId = note.identifier else {
                completion(false, nil)
                return
            }
            
            var user = UserController.currentUser
        }
    }
 
}
