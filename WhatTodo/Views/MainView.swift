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
    @State private var showingDetailView = false
    @State private var title = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(todoItems) { todoItem in
                        TodoItemRow(todoItem: todoItem)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showingDetailView = true
                            }
                            .sheet(isPresented: $showingDetailView) {
                                TodoDetailView(todo: todoItem)
                                    .environment(\.managedObjectContext, context)
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
                        .environment(\.managedObjectContext, context)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
                
                HStack {
                    TextField("Enter something todo.", text: $title)
                    roundAddButton
                }
                .padding()
                .background(Color(UIColor.systemGray3))
                .cornerRadius(10)
                .padding(.horizontal)
            }
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
