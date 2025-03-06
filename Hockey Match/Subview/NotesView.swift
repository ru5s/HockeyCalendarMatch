//
//  NotesView.swift
//  Hockey Match
//
//  Created by DF on 10/06/24.
//

import SwiftUI

struct NotesView: View {
    @Environment (\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \NotesHockey.idNotes, ascending: true)])
    private var allNotes: FetchedResults<NotesHockey>
    @State var editNote: Bool = false
    @State var createNote: Bool = false
    @Binding var dismiss: Bool
    @State var textInNote: String = ""
    @State var disableButton: Bool = true
    @State var choosedNote: NotesHockey?
    var body: some View {
        NavigationView {
            ZStack {
                mainBody
                    .navigationTitle("Notes")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                withAnimation {
                                    createNote.toggle()
                                }
                            }, label: {
                                Text("Create new")
                            })
                            .disabled(editNote)
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss.toggle()
                            }, label: {
                                HStack(spacing: 3) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                            })
                        }
                }
                alerts
            }
        }
    }
    
    private var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack {
                let filteredArray = allNotes.sorted(by: {$0.dateNotes ?? Date() > $1.dateNotes ?? Date()})
                ForEach(filteredArray, id: \.idNotes) { item in
                    notesCell(data: item)
                        .addButtonActions(leadingButtons: [], trailingButton: [.delete, .edit]) { type in
                            if type == .delete {
                                withAnimation {
                                    viewContext.delete(item)
                                    try? viewContext.save()
                                }
                            }
                            if type == .edit {
                                withAnimation {
                                    choosedNote = item
                                    textInNote = item.textNotes ?? ""
                                    editNote.toggle()
                                }
                            }
                        }
                        .padding(.horizontal, -16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 25)
        })
    }
    
    private var alerts: some View {
        ZStack {
            if createNote {
                ZStack {
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                createNote.toggle()
                            }
                        }
                    createNewNote
                        .onAppear(){
                            if textInNote.isEmpty {
                                disableButton = true
                            } else {
                                disableButton = false
                            }
                        }
                }
            }
            
            if editNote {
                ZStack {
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                editNote.toggle()
                            }
                        }
                    createNewNote
                        .onAppear(){
                            if textInNote.isEmpty {
                                disableButton = true
                            } else {
                                disableButton = false
                            }
                        }
                }
            }
        }
    }
    
    private func notesCell(data: NotesHockey) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Date().dateFormatddMMMMHHmm())
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
            Text(data.textNotes ?? "")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
    }
    
    private var createNewNote: some View {
        VStack {
            ZStack(alignment: .topLeading, content: {
                if textInNote.isEmpty {
                    Text("Write a note")
                        .padding(16)
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(textInNote)
                        .font(Font.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .foregroundColor(.white)
                        
                }
                TextEditor(text: $textInNote)
                    .padding(0)
                    .offset(y: 8)
                    .foregroundColor(.clear)
                    .textEditorBackground(Color.clear)
                    .font(Font.system(size: 17, weight: .semibold))
                    .padding(.horizontal, 11)
                    .onChange(of: textInNote, perform: { value in
                        if value.isEmpty {
                            disableButton = true
                        } else {
                            disableButton = false
                        }
                    })
            })
            .frame(maxHeight: 200)
            .background(Color.black)
            .background(Color.black.opacity(0.15))
            .cornerRadiusWithBorder(radius: 16, borderLineWidth: 1, borderColor: .gray, antialiased: true)
            .padding(.horizontal, 16)
            
            Button(action: {
                if editNote {
                    if let choosedNote = choosedNote {
                        CoreDataService.shared.updateNote(viewContext: viewContext, data: textInNote, item: choosedNote)
                    }
                    withAnimation {
                        editNote.toggle()
                        textInNote = ""
                    }
                } else {
                    CoreDataService.shared.saveNote(viewContext: viewContext, data: textInNote)
                    withAnimation {
                        createNote.toggle()
                        textInNote = ""
                    }
                }
                
            }, label: {
                Text("Save note")
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(disableButton ? Color.blue.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            .padding(.horizontal, 16)
            .disabled(disableButton)
        }
    }
    
    private func save() {
        
    }
}

#Preview {
    NotesView(dismiss: .constant(false))
}
