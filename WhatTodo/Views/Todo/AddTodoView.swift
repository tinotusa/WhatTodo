//
//  AddTodoView.swift
//  AddTodoView
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    @State private var title = ""
    @State private var details = ""
    @State private var priority = Priority.low
    @State private var hasReminder = false
    @State private var reminderDate = { () -> Date in
        var components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
        return components.date ?? Date()
    }()
    
    @State private var reminderDays = Weekdays.monday
    @State private var days: Set<Weekdays> = Set(Weekdays.weekdays)
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context

    init(title: String = "") {
        _title = State<String>(wrappedValue: title)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("What do you want to do?", text: $title)
                }
                
                Section(header: Text("Details (optional)")) {
                    TextEditor(text: $details)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text("\(priority.description.capitalized)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                reminderSection
                
                addButton
                    .disabled(!allImportantFieldsFilled)
            }
            .navigationTitle("New todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                        .disabled(!allImportantFieldsFilled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onChange(of: hasReminder) { hasReminder in
                if hasReminder {
                    NotificationsManager.requestUserNotificationAuthorization()
                }
            }
        }
    }
}

private extension AddTodoView {
    // MARK: Form sections
    var reminderSection: some View {
        Section(header: Text("Reminder")) {
            Toggle("Do you want a reminder?", isOn: $hasReminder.animation())
            if hasReminder {
                NavigationLink(destination: DaySelectionView(days: $days)) {
                    HStack {
                        Text(days.isEmpty ? "Tap to select days" : "Every")
                        Spacer()
                        Text(daysToRemindOn(days: days))
                            .foregroundColor(.orange)
                    }
                }
                DatePicker(
                    "At",
                    selection: $reminderDate,
                    displayedComponents: [.hourAndMinute]
                )
            }
        }
    }
    
    // MARK: Other
    var allImportantFieldsFilled: Bool {
        let title = title
        if hasReminder && days.isEmpty {
            return false
        }
        return !title.isEmpty
    }

    var addButton: some View {
        Button(action: addTodo) {
            Text("Add")
        }
    }
    
    func addTodo() {
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.detail = details
        newTodo.priority = priority.rawValue
        newTodo.hasReminder = hasReminder
        newTodo.reminderDate = reminderDate
        newTodo.isComplete = false
        do {
            try context.save()
            NotificationsManager.addNotification(for: newTodo)
        } catch {
            print("Error saving context in \(#function): \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
