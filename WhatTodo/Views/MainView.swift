//
//  ContentView.swift
//  WhatTodo
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [], predicate: nil)
    var todoItems: FetchedResults<Todo>

    @State private var showingAddView = false
    @State private var title = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                List {
                    ForEach(todoItems) { todoItem in
                        NavigationLink(destination: TodoDetailView(todo: todoItem)) {
                            TodoItemRow(todoItem: todoItem)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Todo")
                .sheet(isPresented: $showingAddView) {
                    AddTodoView(title: title)
                        .onDisappear {
                            title = ""
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
            }
            
            // TODO: add background to the stack or text field
            HStack {
                TextField("Enter something todo.", text: $title)
                roundAddButton
            }
            .padding()
            .background(Color(UIColor.systemGray3))
            .cornerRadius(10)
            
        }
    }
}

private extension MainView {
    var roundAddButton: some View {
        Button {
            showingAddView = true
        } label: {
            Image(systemName: "plus")
                .font(.largeTitle)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
    func delete(offsets: IndexSet) {
        offsets.map { todoItems[$0] }
        .forEach {
            context.delete($0)
        }
        do {
            try withAnimation {
                try context.save()
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    var addButton: some View {
        Button {
            showingAddView = true
            // TODO: remove this
//            let todoItem = Todo(context: context)
//            todoItem.id = UUID()
//            todoItem.title = "This is a test"
//            todoItem.detail = "some detail here"
//            todoItem.priority = Priority.high.rawValue
//            todoItem.isComplete = true
//            todoItem.reminderDate = Date()
//            do {
//                try withAnimation {
//                    try context.save()
//                }
//            } catch {
//                print(error)
//            }
            
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(
                \.managedObjectContext,
                PersistenceController.shared.container.viewContext
            )
    }
}
