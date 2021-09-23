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
                        .lineLimit(2)
                    Spacer()
                    
                    priorityAndAlarmBadge
                }
                Spacer()
            }
            .opacity(todoItem.isComplete ? 0.4 : 1)
            .animation(.easeInOut)
        }
    }
}

private extension TodoItemRow {
    var priority: String {
        todoItem.wrappedPriority.description.capitalized
    }
    
    var formattedReminderDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: todoItem.wrappedReminderDate)
    }
    
    var priorityAndAlarmBadge: some View {
        HStack {
            Text(priority)
                .padding(.horizontal, 10)
                .frame(width: 85, height: 20)
                .background(todoItem.wrappedPriority.colour.opacity(0.5))
                .cornerRadius(7)
                .foregroundColor(.white)
            if todoItem.hasReminder {
                Text(formattedReminderDate)
                    .foregroundColor(todoItem.wrappedReminderDate < Date() ? .red : .primary)
                Image(systemName: "alarm")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.black.opacity(0.8))
                
            }
        }
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static var context = PersistenceController.shared.container.viewContext
    static var todoItem = { () -> Todo in
        let todoItem = Todo(context: context)
        todoItem.id = UUID()
        todoItem.title = "Preview title"
        todoItem.detail = "preview detils"
        todoItem.hasReminder = true
        todoItem.reminderDate = Date()
        todoItem.priority = Priority.medium.rawValue
        return todoItem
    }()
    
    static var previews: some View {
//        Text("hello")
        TodoItemRow(todoItem: todoItem)
            .environment(
                \.managedObjectContext,
                 context
            )
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
