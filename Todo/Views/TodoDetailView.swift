import SwiftUI

struct TodoDetailView: View {
    
    let todo: Todo?
    
    var body: some View {
        if let todo {
            Text(todo.name)
        } else {
            Text("Select a todo")
        }
    }
}
