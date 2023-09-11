import SwiftUI

struct TodoItemView: View {
    
    @Binding var todo: Todo
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: $todo.isCompleted)
            
            Text(todo.name)
                .foregroundColor(.primary)
                .font(.headline)
                .strikethrough(todo.completedAt != nil, color: .red)
        }
    }
}
