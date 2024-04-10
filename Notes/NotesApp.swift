//
//  NotesApp.swift
//  Notes
//
//  Created by Ramazan Ozer on 10.04.2024.
//

import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .modelContainer(for: [Note.self])
    }
}
