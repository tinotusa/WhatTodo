//
//  CheckBox.swift
//  CheckBox
//
//  Created by Tino on 4/9/21.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isChecked: Bool
    private let size = 30.0
    
    var body: some View {
        ZStack {
            Color.gray
            if isChecked {
                Text("✅")
            }
        }
        .animation(.default)
        .cornerRadius(10)
        .frame(width: size, height: size)
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        CheckBox(isChecked: .constant(false))
    }
}
