import SwiftUI

struct TodoItemView: View {
    
    @EnvironmentObject var database: AppDatabase
    
    @Binding var todo: Todo   
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: $todo.isCompleted)
            
            TextField(todo.name, text: $todo.name)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .submitLabel(.done)
                .onSubmit {
                    
                }
        }
    }
}
