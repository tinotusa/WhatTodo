//
//  Todo+CoreDataClass.swift
//  Todo
//
//  Created by Tino on 4/9/21.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {
    var wrappedTitle: String {
        get { title ?? "N/A" }
        set { title = newValue }
    }
    
    var wrappedDetail: String {
        get { detail ?? "N/A" }
        set { detail = newValue }
    }
    
    var wrappedPriority: Priority {
        get { Priority(rawValue: priority) ?? .low }
        set { priority = newValue.rawValue }
    }
    
    var wrappedReminderDate: Date {
        get { reminderDate ?? Date() }
        set { reminderDate = newValue }
    }
    
    var wrappedDaysToRepeat: Set<Weekdays> {
        get {
            guard let daysToRepeatData = daysToRepeat else { return [] }
            do {
                return try JSONDecoder().decode(Set<Weekdays>.self, from: daysToRepeatData)
            } catch {
                print(error)
            }
            return []
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                daysToRepeat = data
            } catch {
                print("Failed to encode daysToRepeat: \(error)")
            }
        }
    }
}
