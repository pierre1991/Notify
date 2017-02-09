//
//  NoteController.swift
//  NotifyMe
//
//  Created by Pierre on 10/20/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class NoteController {
    
    static let sharedController = NoteController()
    
	static func fetchNotesForUser(_ user: User, completionHandler: @escaping (_ notes: [Note]?) -> Void) {
        var allNotes: [Note] = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        notesForUser(UserController.sharedController.currentUser) { (notes) -> Void in
            if let notes = notes {
                allNotes = notes
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { () -> Void in
            let orderedNotes = orderNotes(note: allNotes)
            completionHandler(orderedNotes)
        }
    }
    
    
    static func notesForUser(_ user: User, completionHandler: @escaping (_ notes: [Note]?) -> Void) {
        FirebaseController.base.child("/users/\(user.identifier!)").child("noteId").observeSingleEvent(of: .value, with: {snapshot in
            if let noteIdArray = snapshot.value as? [String] {
                var noteArray: [Note] = []
                
                for noteId in noteIdArray {
                    notesFromIdentifier(identifier: noteId, completionHandler: { (notes) -> Void in
                        if let note = notes {
                            noteArray.append(note)
                        }

                        if noteId == noteIdArray.last {
                            let orderedNotes = orderNotes(note: noteArray)
                            completionHandler(orderedNotes)
                        }
                    })
                }
            } else {
                completionHandler(nil)
            }
        })
    }

    
    static func notesFromIdentifier(identifier: String, completionHandler: @escaping (_ note: Note?) -> Void) {
        FirebaseController.dataAtEndpoint(endpoint: "/notes/\(identifier)", completion: {(data) -> Void in
            if let data = data as? [String: AnyObject] {
                let note = Note(jsonValue: data, identifier: identifier)
                
                completionHandler(note)
            } else {
                completionHandler(nil)
            }
        })
    }
    
    
    static func fetchUsersForNote(note: Note, completionHandler: @escaping (_ user: [User]?) -> Void) {
        FirebaseController.base.child("/notes/\(note.identifier!)").child("userIds").observeSingleEvent(of: .value, with: {snapshot in
            if let userIdArray = snapshot.value as? [String] {
                var userArray: [User] = []
                
                for userId in userIdArray {
                    UserController.userForIdentifier(identifier: userId, completionHandler: { (user) in
                        if let user = user {
                            userArray.append(user)
                            completionHandler(userArray)
                        }
                    })
                }
            } else {
                completionHandler([])
            }
        })
    }
    
    //MARK: Create
    static func createNote(title: String, text: String, users: [User], completionHandler: (_ note: Note?) -> Void) {
        var note = Note(title: title, text: text, users: users)
        note.save()
        
        guard let noteId = note.identifier else { completionHandler(nil); return }
        
        var user = UserController.sharedController.currentUser
        user?.noteId?.append(noteId)
        //user?.noteId.append(noteID)
        user?.save()
        
        for var user in users {
            user.noteId?.append(noteId)
            user.save()
        }
        
        completionHandler(note)
    }
 
    //MARK: Update
    
    
    //MARK: Save
    static func saveNote(note: Note) {
        var note = note
        note.save()
    }
    
    // MARK: Delete
    static func deleteNote(note: Note) {
        note.delete()
    }
    
    //MARK: Order
    static func orderNotes(note: [Note]) -> [Note] {
        return note.sorted(by: {$0.0.identifier > $0.1.identifier})
    }
    
}
