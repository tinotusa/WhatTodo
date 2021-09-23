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
    @State private var selectedTodo: Todo?
    @State private var sortDescriptor = NSSortDescriptor(keyPath: \Todo.title, ascending: true)
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                SortedList(sortDescriptor: sortDescriptor, selectedTodo: $selectedTodo)
                .navigationTitle("Todo")
                .sheet(item: $selectedTodo) { selectedTodo in
                    TodoDetailView(todo: selectedTodo)
                        .environment(\.managedObjectContext, context)
                }
                .sheet(isPresented: $showingAddView) {
                    AddTodoView()
                        .environment(\.managedObjectContext, context)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
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
