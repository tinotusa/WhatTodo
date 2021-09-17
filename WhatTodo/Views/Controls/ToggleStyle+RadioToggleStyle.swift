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
            .animation(nil)
            .rotationEffect(.degrees(configuration.isOn ? 360 : 0))
            .scaleEffect(configuration.isOn ? 1.2 : 1)
            .animation(.interpolatingSpring(stiffness: 100, damping: 10))
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
