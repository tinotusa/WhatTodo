//
//  SortedList.swift
//  SortedList
//
//  Created by Tino on 17/9/21.
//

import SwiftUI

struct SortedList: View {
    @Environment(\.managedObjectContext) var context
    let sortDescriptor: NSSortDescriptor
    @FetchRequest var todoItems: FetchedResults<Todo>
    
    @Binding var selectedTodo: Todo?
    
    init(sortDescriptor: NSSortDescriptor, selectedTodo: Binding<Todo?>) {
        self.sortDescriptor = sortDescriptor
        _todoItems = FetchRequest(entity: Todo.entity(), sortDescriptors: [sortDescriptor])
        _selectedTodo = selectedTodo
    }
    
    var body: some View {
        List {
            ForEach(todoItems) { todoItem in
                TodoItemRow(todoItem: todoItem)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTodo = todoItem
                    }
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(offsets: IndexSet) {
        offsets.map { todoItems[$0] }
        .forEach { item in
            context.delete(item)
        }
        context.perform {
            do {
                try withAnimation {
                    try context.save()
                }
            } catch {
                print(error)
            }
        }
    }
}

struct SortedList_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        SortedList(
            sortDescriptor: NSSortDescriptor(keyPath: \Todo.title, ascending: true),
            selectedTodo: .constant(Todo(context: context)))
            .environment(
                \.managedObjectContext,
                 context
            )
    }
}
