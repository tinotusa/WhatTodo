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
                Text(description)
                    .padding(.horizontal, 10)
                    .background(todoItem.wrappedPriority.colour)
                    .cornerRadius(10)
            }
            Spacer()
            VStack {
                Text("Every Tue")
                Text("At \(formattedTime)")
            }
        }
    }
    
    private var description: String {
        todoItem.wrappedPriority.description.capitalized
    }
    
    private var formattedTime: String {
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
