import SwiftUI
import SwiftData

struct TodoItemView: View {
    
    @State private var viewModel: ViewModel
    
    init(
        context: ModelContext,
        todo: Todo
    ) {
        let viewModel = ViewModel(
            context: context,
            todo: todo
        )
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        HStack {
            CheckboxView(isChecked: .init(
                get: { viewModel.todo.isCompleted },
                set: { value in
                    viewModel.updateCompleted(value: value)
                }
            ))
            
            TextField(viewModel.todo.name, text: $viewModel.todo.name)
                .strikethrough(viewModel.todo.isCompleted)
                .foregroundColor(viewModel.todo.isCompleted ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .submitLabel(.done)
                .onSubmit {
                    
                }
                .fixedSize()
            
            Spacer()
            
            Button {
                viewModel.toggleIsImportant()
            } label: {
                Image(systemName: viewModel.todo.isImportant ? "star.fill" : "star")
            }
        }
    }
}

extension TodoItemView {
    
    @Observable
    final class ViewModel {
        
        var context: ModelContext
        var todo: Todo
        
        init(
            context: ModelContext,
            todo: Todo
        ) {
            self.context = context
            self.todo = todo
        }
        
        func updateCompleted(value: Bool) {
            self.todo.completedAt = value ? Date() : nil
        }
        
        func toggleIsImportant() {
            self.todo.isImportant.toggle()
        }
    }
}
