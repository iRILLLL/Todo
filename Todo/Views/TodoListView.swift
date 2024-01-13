import SwiftUI
import SwiftData

struct TodoListView: View {
    
    private var context: ModelContext
    @State private var viewModel: ViewModel
    @Binding private var navPath: NavigationPath
    private let menu: Menu
    
    init(
        context: ModelContext,
        navPath: Binding<NavigationPath>,
        menu: Menu
    ) {
        let viewModel = ViewModel(context: context)
        _viewModel = State(initialValue: viewModel)
        _navPath = navPath
        self.menu = menu
        self.context = context
    }
    
    @FocusState private var focusedTodo: UUID?
    
    var body: some View {
        List {
            ForEach(viewModel.todos, id: \.self) { todo in
                Button {
                    navPath.append(todo)
                } label: {
                    TodoItemView(
                        todo: todo,
                        isCompleted: .init(
                            get: { todo.isCompleted },
                            set: { value in
                                viewModel.changeCompleted(value: value, of: todo)
                            }
                        )
                    )
                    .focused($focusedTodo, equals: todo.id)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.delete(todo: todo)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .toolbar(id: UUID().uuidString) {
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    withAnimation {
                        let id = viewModel.addNewTodo()
                        focusedTodo = id
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Todos")
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)    }
}

extension TodoListView {
    
    @Observable
    final class ViewModel {
        
        var context: ModelContext
        var todos: [Todo] = []
        
        init(context: ModelContext) {
            self.context = context
            fetchTodos()
        }
        
        func addNewTodo() -> UUID {
            let id = UUID()
            let todo = Todo(
                id: id,
                createdAt: Date()
            )
            context.insert(todo)
            fetchTodos()
            return id
        }
        
        func changeCompleted(value: Bool, of todo: Todo) {
            guard let index = todos.firstIndex(of: todo) else { return }
            todos[index].completedAt = value ? Date() : nil
            fetchTodos()
        }
        
        func delete(todo: Todo) {
            context.delete(todo)
        }
        
        func fetchTodos() {
            let todos = FetchDescriptor<Todo>(
                sortBy: [
                    SortDescriptor(\.completedAt, order: .forward),
                    SortDescriptor(\.createdAt, order: .reverse)
                ]
            )
            do {
                self.todos = try context.fetch(todos)
            } catch {
                print(error)
            }
        }
    }
}
