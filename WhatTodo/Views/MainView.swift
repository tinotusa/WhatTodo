//
//  ContentView.swift
//  WhatTodo
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData
import UserNotifications

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [], predicate: nil)
    var todoItems: FetchedResults<Todo>

    @State private var showingAddView = false
    @State private var showingDetailView = false
    @State private var title = ""
    @State private var selectedTodo: Todo?

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(todoItems) { todoItem in
                        TodoItemRow(todoItem: todoItem)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTodo = todoItem
                                showingDetailView = true
                            }
                            
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Todo")
                .sheet(item: $selectedTodo) { selectedTodo in
                    TodoDetailView(todo: selectedTodo)
                        .environment(\.managedObjectContext, context)
                        .onDisappear {
                            try? context.save()
                        }
                }
                .sheet(isPresented: $showingAddView) {
                    AddTodoView(title: title)
                        .onDisappear {
                            title = ""
                        }
                        .environment(\.managedObjectContext, context)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
                    // TODO: - look up how to change sort descriptors
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Name",       action: sortByName)
                            Button("Priority",   action: sortByPriority)
                            Button("Date added", action: sortByDate)
                        } label: {
                            Text("Sort")
                        }
                    }
                }
                
                inputBar
            }
        }
    }
}

private extension MainView {
  
    func sortByName() {
    }
    
    func sortByPriority() {
    }
    
    func sortByDate() {
    }
    
    var inputBar: some View {
        HStack {
            TextField("Enter something todo.", text: $title)
            roundAddButton
        }
        .padding()
        .background(Color(UIColor.systemGray3))
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
    
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
