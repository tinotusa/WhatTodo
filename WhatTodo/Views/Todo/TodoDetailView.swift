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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var todo: Todo

    var body: some View {
        Form {
            completeTodoSection
            
            titleSection
            
            detailsSection
            
            prioritySection
            
            reminderSection
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

private extension TodoDetailView {
    var completeTodoSection: some View {
        Toggle(isOn: $todo.isComplete) {
            Text("Complete")
        }
    }
    
    var titleSection: some View  {
        Section(header: Text("Title")) {
            TextField("Todo title", text: $todo.wrappedTitle)
        }
    }
    
    var detailsSection: some View {
        Section(header: Text("Details")) {
            TextEditor(text: $todo.wrappedDetail)
                .frame(height: 100)
        }
    }
    
    var prioritySection: some View {
        Section(header: Text("Priority")) {
            Picker("Priority", selection: $todo.priority) {
                ForEach(Priority.allCases) { priority in
                    Text(priority.description.capitalized)
                        .tag(priority.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var reminderSection: some View {
        Section(header: Text("Reminder")) {
            Toggle(isOn: $todo.hasReminder.animation()) {
                Text("Remind me")
            }
            if todo.hasReminder {
                DatePicker(
                    "Date",
                    selection: $todo.wrappedReminderDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "Time",
                    selection: $todo.wrappedReminderDate,
                    displayedComponents: [.hourAndMinute]
                )
            }
        }
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
        NavigationView {
            TodoDetailView(todo: todoItem)
                .environment(
                    \.managedObjectContext,
                     context
                )
        }
    }
}
