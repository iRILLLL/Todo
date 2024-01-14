import SwiftUI
import SwiftData
import TodoInterface

public struct TodoListView: View {
    
    @State private var viewModel: ViewModel
    @Binding private var navPath: NavigationPath
    private var sidebarMenu: SidebarMenu?
    
    public init(
        modelContext: ModelContext,
        navPath: Binding<NavigationPath>,
        sidebarMenu: SidebarMenu?
    ) {
        _viewModel = State(
            initialValue: ViewModel(
                modelContext: modelContext,
                sidebarMenu: sidebarMenu
            )
        )
        _navPath = navPath
        self.sidebarMenu = sidebarMenu
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
                                todo.completedAt = value ? Date() : nil
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
        .navigationTitle(sidebarMenu?.text ?? "")
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
    }
}

extension TodoListView {
    
    @Observable
    final class ViewModel {
        
        private(set) var todos = [Todo]()
        
        private let modelContext: ModelContext
        private let sidebarMenu: SidebarMenu?
        
        init(
            modelContext: ModelContext,
            sidebarMenu: SidebarMenu?
        ) {
            self.modelContext = modelContext
            self.sidebarMenu = sidebarMenu
            self.fetchTodos()
        }
        
        func delete(todo: Todo) {
            modelContext.delete(todo)
        }
        
        func addNewTodo() -> UUID {
            let id = UUID()
            let todo = Todo(
                id: id,
                createdAt: Date()
            )
            modelContext.insert(todo)
            fetchTodos()
            return id
        }
        
        func fetchTodos() {
            
            let sidebarMenu = self.sidebarMenu ?? .today
            
            let sortBy: [SortDescriptor] = [
                SortDescriptor(\Todo.completedAt, order: .forward),
                SortDescriptor(\.createdAt, order: .reverse)
            ]
            
            let descriptor: FetchDescriptor<Todo>
            
            switch sidebarMenu {
            case .today:
                descriptor = FetchDescriptor<Todo>(
                    sortBy: sortBy
                )
            case .important:
                descriptor = FetchDescriptor<Todo>(
                    predicate: #Predicate { $0.isImportant },
                    sortBy: sortBy
                )
            }
            
            do {
                self.todos = try modelContext.fetch(descriptor)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
