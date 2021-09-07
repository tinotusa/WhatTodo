//
//  TodoDetailView.swift
//  TodoDetailView
//
//  Created by Tino on 5/9/21.
//

import SwiftUI
import CoreData

struct TodoDetailView: View {
    @Environment(\.managedObjectContext) var context
    let todo: Todo
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                Text(todo.wrappedTitle)
            }
            Section(header: Text("Details")) {
                Text(todo.wrappedDetail)
            }
            Section(header: Text("Reminder")) {
                Text(reminderText)
                
            }
        }
        .navigationTitle("Details")
    }

    private var reminderText: String {
        var text = "\(todo.hasReminder ? "Has" : "No") reminder set"
        if todo.hasReminder {
            text += " at \(formattedDate)"
        }
        return text
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: todo.reminderDate ?? Date())
    }
}

struct TodoDetailView_Previews: PreviewProvider {
    static var context = PersistenceController.shared.container.viewContext
    static var todoItem = { () -> Todo in
        let todo = Todo(context: context)
        todo.id = UUID()
        todo.title = "This is a test"
        todo.detail = """
            1. one
            2. two
            3. tree
        """
        todo.isComplete = false
        todo.hasReminder = true
        todo.reminderDate = Date()
        todo.priority = Priority.low.rawValue
        return todo
    }()
    
    static var previews: some View {
        TodoDetailView(todo: todoItem)
            .environment(
                \.managedObjectContext,
                 context
            )
    }
}
