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
        title ?? "Unknown title"
    }
    var wrappedPriority: Priority {
        switch priority {
        case 0: return .low
        case 1: return .medium
        case 2: return .high
        default:
            fatalError("Invalid priority \(priority)")
        }
    }
}
