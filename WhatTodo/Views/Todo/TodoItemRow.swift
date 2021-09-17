//
//  TodoItemRow.swift
//  TodoItemRow
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData

struct TodoItemRow: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var todoItem: Todo
    
    var body: some View {
        HStack {
            Toggle("Complete task", isOn: $todoItem.isComplete)
                .toggleStyle(.radioToggleStyle)
            Group {
                VStack(alignment: .leading) {
                    Text(todoItem.wrappedTitle)
                    Spacer()
                    Text(priority)
                        .padding(.horizontal, 10)
                        .frame(width: 85, height: 20)
                        .background(todoItem.wrappedPriority.colour.opacity(0.5))
                        .cornerRadius(7)
                        .foregroundColor(.white)
                        
                }
                Spacer()
            }
            .opacity(todoItem.isComplete ? 0.4 : 1)
        }
    }
}

private extension TodoItemRow {
    var priority: String {
        todoItem.wrappedPriority.description.capitalized
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: todoItem.reminderDate ?? Date())
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static var context = PersistenceController.shared.container.viewContext
    static var todoItem = { () -> Todo in
        let todoItem = Todo(context: context)
        todoItem.id = UUID()
        todoItem.title = "Preview title"
        todoItem.detail = "preview detils"
        todoItem.priority = Priority.medium.rawValue
        return todoItem
    }()
    
    static var previews: some View {
        TodoItemRow(todoItem: todoItem)
            .environment(
                \.managedObjectContext,
                 context
            )
    }
}
