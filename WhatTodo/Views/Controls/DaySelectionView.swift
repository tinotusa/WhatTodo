//
//  DaySelectionView.swift
//  DaySelectionView
//
//  Created by Tino on 7/9/21.
//

import SwiftUI

struct DaySelectionView: View {
    @Binding var days: Set<Weekdays>
    
    var body: some View {
        Form {
            ForEach(Weekdays.allCases) { day in
                HStack {
                    Text(day.rawValue.capitalized)
                    Spacer()
                    Image(systemName: days.contains(day) ? "checkmark" : "circle")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if !days.contains(day) {
                        days.insert(day)
                    } else {
                        days.remove(day)
                    }
                }
            }
        }
        .navigationBarTitle("Days to remind")
    }
}

struct DaySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DaySelectionView(days: .constant([]))
    }
}
