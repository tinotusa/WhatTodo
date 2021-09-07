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
        var components = DateComponents(calendar: .current)
        components.hour = 18
        return components.date ?? Date()
    }()
    
    @State private var reminderDays = Weekdays.monday
    @State private var days: Set<Weekdays> = Set(Weekdays.weekdays)
    
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
                        NavigationLink(destination: DaySelectionView(days: $days)) {
                            HStack {
                                Text(days.isEmpty ? "Tap to select days" : "Every")
                                Spacer()
                                Text(daysToRemindOn.capitalized)
                                    .foregroundColor(.orange)
                            }
                        }
                        DatePicker("At", selection: $reminderDate, displayedComponents: [.hourAndMinute])
                    }
                }
                addButton
                    .disabled(!allImportantFieldsFilled)
            }
            .navigationTitle("New todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                        .disabled(!allImportantFieldsFilled)
                }
        }
        }
    }
    
    private var allImportantFieldsFilled: Bool {
        let title = title
        if hasReminder && days.isEmpty {
            return false
        }
        return !title.isEmpty
    }
    
    private var daysToRemindOn: String {
        if days.count == Weekdays.allCases.count {
            return "Day"
        }
        if days.count == 5 && days.allSatisfy({ $0 > Weekdays.sunday && $0 < Weekdays.saturday }) {
            return "Weekday"
        }
        if days.count == 2 && days.allSatisfy({ $0 == Weekdays.sunday || $0 == Weekdays.saturday }) {
            return "Weekend"
        }
        let days = days
            .sorted()
            .map { $0.shortForm }
        return ListFormatter.localizedString(byJoining: days)
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
