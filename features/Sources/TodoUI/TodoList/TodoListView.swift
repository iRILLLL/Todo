import SwiftUI
import SwiftData
import TodoInterface

public struct TodoListView: View {
    
    @State private var viewModel: ViewModel
    @Binding private var navPath: NavigationPath
    private var group: TodoGroup
    
    public init(
        modelContext: ModelContext,
        navPath: Binding<NavigationPath>,
        group: TodoGroup
    ) {
        _viewModel = State(
            initialValue: ViewModel(
                modelContext: modelContext,
                group: group
            )
        )
        _navPath = navPath
        self.group = group
    }
    
    @FocusState private var focusedTodo: UUID?
    
    public var body: some View {
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
                                viewModel.toggleChanged(todo: todo, value: value)
                            }
                        ),
                        isImportant: .init(
                            get: { todo.isImportant },
                            set: { value in
                                viewModel.starredChanged(todo: todo, value: value)
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
        .animation(.default, value: viewModel.todos)
        .onChange(of: focusedTodo) { oldValue, newValue in
            guard
                oldValue != nil && oldValue != newValue
            else { return }
            viewModel.keyboardFocusChanged()
        }
        .toolbar(id: UUID().uuidString) {
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    withAnimation {
                        let newTodoID = viewModel.addNewTodo()
                        focusedTodo = newTodoID
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle(group.name)
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
    }
}

extension TodoListView {
    
    @Observable
    final class ViewModel {
        
        private(set) var todos = [Todo]()
        
        private var recentlyAddedTodo: Todo?
        
        private let modelContext: ModelContext
        private let group: TodoGroup
        
        init(
            modelContext: ModelContext,
            group: TodoGroup
        ) {
            self.modelContext = modelContext
            self.group = group
            self.fetchTodos()
        }
        
        func delete(todo: Todo) {
            modelContext.delete(todo)
            fetchTodos()
        }
        
        func keyboardFocusChanged() {
            guard 
                let recentlyAddedTodo,
                recentlyAddedTodo.name.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            else {
                self.recentlyAddedTodo = nil
                return
            }
            
            modelContext.delete(recentlyAddedTodo)
            self.recentlyAddedTodo = nil
            self.fetchTodos()
        }
        
        func addNewTodo() -> UUID {
            let id = UUID()
            let todo = Todo(
                id: id,
                group: self.group,
                createdAt: Date()
            )
            self.recentlyAddedTodo = todo
            modelContext.insert(todo)
            fetchTodos()
            return id
        }
        
        func starredChanged(todo: Todo, value: Bool) {
            todo.isImportant = value
            fetchTodos()
        }
        
        func toggleChanged(todo: Todo, value: Bool) {
            todo.completedAt = value ? Date() : nil
            fetchTodos()
        }
        
        func fetchTodos() {
            
            let sortBy: [SortDescriptor] = [
                SortDescriptor(\Todo.completedAt, order: .forward),
                SortDescriptor(\.createdAt, order: .reverse)
            ]
            
            let groupName = self.group.name
            
            let descriptor = FetchDescriptor<Todo>(
                predicate: #Predicate { $0.group.name == groupName },
                sortBy: sortBy
            )
            
            do {
                self.todos = try modelContext.fetch(descriptor)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
