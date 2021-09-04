//
//  Priority.swift
//  Priority
//
//  Created by Tino on 4/9/21.
//

import SwiftUI

enum Priority: Int16, Codable, Identifiable, CaseIterable, CustomStringConvertible {
    case low, medium, high
    
    var id: Priority {
        self
    }
    
    var description: String {
        switch self {
        case .low: return "low"
        case .medium: return "medium"
        case .high: return "high"
        }
    }
    
    var colour: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .red
        }
    }
}
