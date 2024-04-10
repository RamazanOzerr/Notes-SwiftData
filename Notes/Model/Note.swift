//
//  Note.swift
//  Notes
//
//  Created by Ramazan Ozer on 10.04.2024.
//

import Foundation
import SwiftData

@Model
class Note{
    
    var title: String
    var noteBody: String
    var date: Date
    
    init(title: String, noteBody: String, date: Date) {
        self.title = title
        self.noteBody = noteBody
        self.date = date
    }
    
 
    
}
