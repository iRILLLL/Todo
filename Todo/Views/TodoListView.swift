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
                    TodoItemView(context: self.context, todo: todo)
                        .focused($focusedTodo, equals: todo.id)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
//                                guard let id = todo.id else { return }
//                                Task {
//                                    try? await database.deleteTodos(ids: [id])
//                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
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
            todos.insert(todo, at: 0)
            context.insert(todo)
            return id
        }
        
        func fetchTodos() {
            let todos = FetchDescriptor<Todo>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            do {
                self.todos = try context.fetch(todos)
            } catch {
                print(error)
            }
        }
    }
}
