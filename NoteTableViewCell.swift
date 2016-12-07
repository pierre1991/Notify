//
//  NoteTableViewCell.swift
//  NotifyMe
//
//  Created by Pierre on 11/29/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    
    //MARK: IBOulets
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateNote(note: Note) {
        noteTitleLabel.text = note.title
        noteBodyLabel.text = note.text
    }

}

extension NoteTableViewCell {
    
    
}
