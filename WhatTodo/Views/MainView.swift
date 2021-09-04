//
//  ContentView.swift
//  WhatTodo
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData

struct TodoItemRow: View {
    @Environment(\.managedObjectContext) var context
    
    let todoItem: Todo
    @State private var isChecked: Bool = false
    
    init(todoItem: Todo) {
        self.todoItem = todoItem
        _isChecked = State<Bool>(wrappedValue: todoItem.isComplete)
    }
    
    var body: some View {
        let _isChecked = Binding<Bool>(
            get: { isChecked },
            set: {
                isChecked = $0
                todoItem.isComplete = isChecked
                try? context.save()
            }
        )
        
        return HStack {
            CheckBox(isChecked: _isChecked)
            VStack(alignment: .leading) {
                Text(todoItem.wrappedTitle)
                Text(todoItem.wrappedPriority.rawValue)
            }
            Spacer()
            VStack {
                Text("Every Tue")
                Text("At \(formattedTime)")
            }
        }
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: todoItem.reminderDate ?? Date())
    }
}

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [], predicate: nil)
    var todoItems: FetchedResults<Todo>

    var body: some View {
        NavigationView {
            List {
                ForEach(todoItems) { todoItem in
                    TodoItemRow(todoItem: todoItem)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
    }
}

struct CheckBox: View {
    @Binding var isChecked: Bool
    private let size = 30.0
    
    var body: some View {
        ZStack {
            Color.gray
            if isChecked {
                Text("✅")
            }
        }
        .animation(.default)
        .cornerRadius(10)
        .frame(width: size, height: size)
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

enum Priority: String, Codable {
    case low, medium, high
    var value: Int16 {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }
}

private extension MainView {
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
            let todoItem = Todo(context: context)
            todoItem.id = UUID()
            todoItem.title = "This is a test"
            todoItem.detail = "some detail here"
            todoItem.priority = Priority.high.value
            todoItem.isComplete = true
            todoItem.reminderDate = Date()
            do {
                try withAnimation {
                    try context.save()
                }
            } catch {
                print(error)
            }
            
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
