//
//  SortOrder.swift
//  SortOrder
//
//  Created by Tino on 17/9/21.
//

import SwiftUI

enum SortOrder: String, Identifiable, CaseIterable {
    case name = "Name"
    case priority = "Priority"
    case date = "Date added"
    case completed = "Completed"
    
    var id: Self {
        self
    }
    
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .name:
            return NSSortDescriptor(keyPath: \Todo.title, ascending: true)
        case .priority:
            return NSSortDescriptor(keyPath: \Todo.priority, ascending: false)
        case .date:
            return NSSortDescriptor(keyPath: \Todo.reminderDate, ascending: true)
        case .completed:
            return NSSortDescriptor(keyPath: \Todo.isComplete, ascending: false)
        }
    }
      
}
