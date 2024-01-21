import SwiftUI
import SwiftData
import TodoInterface

public struct TodoListView: View {
    
    @State private var viewModel: ViewModel
    @State private var navigationTitle: String
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
        _navigationTitle = State(initialValue: group.name)
        _navPath = navPath
        self.group = group
    }
    
    @FocusState private var focusedTodo: UUID?
    @FocusState private var focused: UUID?
    private var textFieldFocusID = UUID()
    
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if group.name == "New Group" {
                    self.focused = self.textFieldFocusID
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
        .navigationTitle($navigationTitle)
        .onChange(of: navigationTitle) { oldValue, newValue in
            if newValue.isEmpty {
                navigationTitle = oldValue
            } else {
                viewModel.navigationTitleChanged(title: newValue)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
    }
}

extension TodoListView {
    
    @Observable
    final class ViewModel {
        
        private(set) var todos = [Todo]()
        
        // if recently added todo is empty text, then delete when keyboard out of focus
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
                createdAt: Date()
            )
            self.recentlyAddedTodo = todo
            modelContext.insert(todo)
            todo.group = self.group
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
                predicate: #Predicate { $0.group?.name == groupName },
                sortBy: sortBy
            )
            
            do {
                self.todos = try modelContext.fetch(descriptor)
            } catch {
                print(error)
            }
        }
        
        func navigationTitleChanged(title: String) {
            group.name = title
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }
    }
}
