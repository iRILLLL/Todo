import SwiftUI

struct TodoItemView: View {
    
    @Binding var todo: Todo
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: $todo.isCompleted)
            
            TextField("Todo", text: $todo.name)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
