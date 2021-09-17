//
//  ToggleStyle+RadioToggleStyle.swift
//  ToggleStyle+RadioToggleStyle
//
//  Created by Tino on 14/9/21.
//

import SwiftUI

struct RadioToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle.inset.filled")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(configuration.isOn ? .green : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

extension ToggleStyle where Self == RadioToggleStyle {
    static var radioToggleStyle: RadioToggleStyle {
        RadioToggleStyle()
    }
}
