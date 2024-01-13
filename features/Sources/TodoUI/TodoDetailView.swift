import SwiftUI
import TodoInterface

public struct TodoDetailView: View {
    
    let todo: Todo
    
    public init(todo: Todo) {
        self.todo = todo
    }
    
    @State private var name: String = ""
    
    public var body: some View {
        Form {
            Section {
                TextField(todo.name, text: $name)
            }
            Section {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "bell")
                        Text("Remind Me")
                    }
                }
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Add Due Date")
                    }
                }
            }
        }
        .toolbar(id: UUID().uuidString) {
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    
                } label: {
                    Image(systemName: "star")
                }
            }
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    
                } label: {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Add Todo")
        .onAppear {
            if todo.name != "Todo" {
                name = todo.name
            }
        }
    }
}
