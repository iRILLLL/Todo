import SwiftUI

struct TodoDetailView: View {
    
    let todo: Todo
    
    @State private var name: String = ""
    
    enum Field {
        case name
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form {
            Section {
                TextField(todo.name, text: $name)
                    .focused($focusedField, equals: .name)
            }
        }
        .toolbar(id: UUID().uuidString) {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .name
            }
        }
    }
}
