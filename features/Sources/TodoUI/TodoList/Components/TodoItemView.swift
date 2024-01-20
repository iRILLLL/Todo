import SwiftUI
import SwiftData
import TodoInterface

struct TodoItemView: View {
    
    @Bindable var todo: Todo 
    @Binding var isCompleted: Bool
    @Binding var isImportant: Bool
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: $isCompleted)
            
            TextField(todo.name, text: $todo.name)
                .strikethrough(isCompleted)
                .foregroundColor(isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .submitLabel(.done)
            
            Spacer()
            
            Button {
                isImportant.toggle()
            } label: {
                Image(systemName: isImportant ? "star.fill" : "star")
            }
        }
    }
}
