//
//  Weekdays.swift
//  Weekdays
//
//  Created by Tino on 7/9/21.
//

import Foundation

enum Weekdays: String, Codable, Identifiable, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    // Codable conformance
    var id: Weekdays {
        self
    }
    
    /// A shorter representation of the week day's name
    var shortForm: String {
        String(Array<Character>(rawValue)[0...2])
    }
    
    /// The index of the day
    var index: Int {
        switch self {
        case .sunday:    return 0
        case .monday:    return 1
        case .tuesday:   return 2
        case .wednesday: return 3
        case .thursday:  return 4
        case .friday:    return 5
        case .saturday:  return 6
        }
    }
    
    static var weekdays: [Weekdays] {
        var days = allCases.dropFirst()
        days = days.dropLast()
        return Array(days)
    }
}

func daysToRemindOn(days: Set<Weekdays>) -> String {
    if days.count == Weekdays.allCases.count {
        return "Day"
    }
    if days.count == 5 && days.allSatisfy({ $0 > Weekdays.sunday && $0 < Weekdays.saturday }) {
        return "Weekday"
    }
    if days.count == 2 && days.allSatisfy({ $0 == Weekdays.sunday || $0 == Weekdays.saturday }) {
        return "Weekend"
    }
    let stringDays = days
        .sorted()
        .map { $0.shortForm }
    
    return ListFormatter.localizedString(byJoining: stringDays)
}

extension Weekdays: Comparable {
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.index < rhs.index
    }
}
