//
//  ContentView.swift
//  Notes
//
//  Created by Ramazan Ozer on 10.04.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingItemSheet = false
        @Query(sort: \Note.date) var notes: [Note]
        @Environment(\.modelContext) var context
        @State private var noteToEdit: Note?
        
        var body: some View {
            NavigationStack{
                
                ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(0..<notes.count / 2 + notes.count % 2, id: \.self) { row in
                                    HStack(spacing: 16) {
                                        ForEach(row * 2..<min(row * 2 + 2, notes.count), id: \.self) { index in
                                            ExpenseCell(note: notes[index])
                                                .frame(maxWidth: .infinity)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    noteToEdit = notes[index]
                                                }
                                                .contextMenu {
                                                    Button("Delete") {
                                                        context.delete(notes[index])
                                                        try? context.save()
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                
                .padding()
                .navigationTitle("Notes")
                .navigationBarTitleDisplayMode(.large)
                .sheet(isPresented: $isShowingItemSheet) {
                    AddNoteSheet()
                }
                .sheet(item: $noteToEdit) {note in
                    UpdateNoteSheet(note: note)
                }
                .toolbar{
                    if !notes.isEmpty {
                        Button("Add Note", systemImage: "plus"){
                            isShowingItemSheet = true
                        }
                    }
                }
                
                .overlay{
                    if notes.isEmpty {
                        
                        VStack{
                                    ContentUnavailableView(label: {
                                        Label("No Notes", systemImage: "list.bullet.rectangle.portrait")
                                            .font(.title3)
                                    }, description: {
                                        Text("Start adding notes")
                                            .foregroundColor(.secondary)
                                          
                                    }, actions: {
                                        Button("Add Note") {
                                            isShowingItemSheet = true
                                        }
                                        .buttonStyle(.borderedProminent)
                                    })
                          
                                }
                   
                    }
                }
            }
        }
}

#Preview {
    ContentView()
}

struct ExpenseCell: View {
    
    let note: Note
    var body: some View{
        
        ZStack{
            Color(.white)
                .ignoresSafeArea()
                .cornerRadius(15)
            
            VStack{
                Text(note.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Text(note.noteBody)
            }
        }
        .padding()
        .background(Rectangle()
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        )
    }
}


struct AddNoteSheet: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = " "
    @State private var date: Date = .now
    @State private var noteBody: String = " "
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Note title", text: $title)
                TextField("Note body", text: $noteBody)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                        
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("Save"){
                        // Save code goes here
                        let note = Note(title: title, noteBody: noteBody, date: date)
                        
                        
                        // it auto saves the data
                        context.insert(note)
                        // try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateNoteSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Note title", text: $note.title)
                TextField("Body", text: $note.noteBody)
            }
            .navigationTitle("Update Note")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("Done"){
                        dismiss()
                    }
                }
               
            }
        }
    }
}

