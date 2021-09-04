//
//  WhatTodoApp.swift
//  WhatTodo
//
//  Created by Tino on 4/9/21.
//

import SwiftUI

@main
struct WhatTodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
