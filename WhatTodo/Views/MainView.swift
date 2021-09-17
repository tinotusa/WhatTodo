//
//  ContentView.swift
//  WhatTodo
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData
import UserNotifications

// TODO: - Add dates to add todo view

struct SortedList: View {
    @Environment(\.managedObjectContext) var context
    let sortDescriptor: NSSortDescriptor
    @FetchRequest var todoItems: FetchedResults<Todo>
    
    @Binding var selectedTodo: Todo?
    
    init(sortDescriptor: NSSortDescriptor, selectedTodo: Binding<Todo?>) {
        self.sortDescriptor = sortDescriptor
        _todoItems = FetchRequest(entity: Todo.entity(), sortDescriptors: [sortDescriptor])
        _selectedTodo = selectedTodo
    }
    
    var body: some View {
        ForEach(todoItems) { todoItem in
            TodoItemRow(todoItem: todoItem)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTodo = todoItem
                }
        }
        .onDelete(perform: delete)
    }
    
    private func delete(offsets: IndexSet) {
        offsets.map { todoItems[$0] }
        .forEach { item in
            context.delete(item)
        }
        do {
            try withAnimation {
                try context.save()
            }
        } catch {
            print("Failed to delete Todo item: \(error)")
        }
    }
}

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [], predicate: nil)
    var todoItems: FetchedResults<Todo>

    @State private var showingAddView = false
    @State private var title = ""
    @State private var selectedTodo: Todo?
    @State private var sortDescriptor = NSSortDescriptor(keyPath: \Todo.title, ascending: true)
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    SortedList(sortDescriptor: sortDescriptor, selectedTodo: $selectedTodo)
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
                            ForEach(SortOrder.allCases) { order in
                                Button(order.rawValue, action: {sort(by: order) })
                            }
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
    func sort(by sortOrder: SortOrder) {
        withAnimation {
            sortDescriptor = sortOrder.sortDescriptor
        }
    }
    var inputBar: some View {
        HStack {
            TextField("Enter something todo.", text: $title)
            roundAddButton
        }
        .padding()
        .background(Color(UIColor.systemGray3))
        .cornerRadius(50)
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
