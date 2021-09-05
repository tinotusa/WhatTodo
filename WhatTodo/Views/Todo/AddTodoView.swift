//
//  AddTodoView.swift
//  AddTodoView
//
//  Created by Tino on 4/9/21.
//

import SwiftUI
import CoreData

enum Weekdays: String, Codable, Identifiable, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var id: Weekdays {
        self
    }
}

struct AddTodoView: View {
    @State private var title = ""
    @State private var details = ""
    @State private var priority = Priority.low
    @State private var hasReminder = false
    @State private var reminderDate = { () -> Date in
        var components = DateComponents(calendar: .current)
        components.hour = 18
        return components.date ?? Date()
    }()
    
    @State private var reminderDays = Weekdays.monday
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    // NOTE: is having an init bad practice
    // don't know how to do this otherwise
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
                
                Section(header: Text("Reminder")) {
                    Toggle("Do you want a reminder?", isOn: $hasReminder.animation())
                    if hasReminder {
                        Picker("Repeat", selection: $reminderDays) {
                            ForEach(Weekdays.allCases) { weekday in
                                Text("\(weekday.rawValue.capitalized)")
                            }
                        }
                        DatePicker("At", selection: $reminderDate, displayedComponents: [.hourAndMinute])
                    }
                }
                addButton
            }
            .navigationTitle("New todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
        }
        }
    }
    
    private var addButton: some View {
        Button(action: addTodo) {
            Text("Add")
        }
    }
    
    private func addTodo() {
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
