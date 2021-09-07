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
        title ?? "N/A"
    }

    var wrappedDetail: String {
        detail ?? "N/A"
    }
    
    var wrappedPriority: Priority {
        Priority(rawValue: priority) ?? .low
    }
}
