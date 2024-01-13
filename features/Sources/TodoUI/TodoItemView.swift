import SwiftUI
import SwiftData
import TodoInterface

struct TodoItemView: View {
    
    @Bindable var todo: Todo 
    @Binding var isCompleted: Bool
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: $isCompleted)
            
            TextField(todo.name, text: $todo.name)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .submitLabel(.done)
                .fixedSize()
            
            Spacer()
            
            Button {
                todo.isImportant.toggle()
            } label: {
                Image(systemName: todo.isImportant ? "star.fill" : "star")
            }
        }
    }
}
