import SwiftUI
import SwiftData
import TodoInterface

public struct TodoListView: View {
    
    @Query private var todos: [Todo]
    @Environment(\.modelContext) var modelContext
    @State private var selectedTodo: Todo?
    
    @Binding private var navPath: NavigationPath
    private var menu: SidebarMenu?
    
    public init(
        navPath: Binding<NavigationPath>,
        menu: SidebarMenu?
    ) {
        _navPath = navPath
        self.menu = menu
        
        let sort: [SortDescriptor] = [
            SortDescriptor(\Todo.completedAt, order: .forward),
            SortDescriptor(\.createdAt, order: .reverse)
        ]
        
        switch menu {
        case .today:
            _todos = Query(sort: sort)
        case .important:
            _todos = Query(
                filter: #Predicate { $0.isImportant },
                sort: sort
            )
        case .none:
            _todos = Query()
        }
    }
    
    @FocusState private var focusedTodo: UUID?
    
    public var body: some View {
        List {
            ForEach(todos, id: \.self) { todo in
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
                        modelContext.delete(todo)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .animation(.default, value: todos)
        .toolbar(id: UUID().uuidString) {
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    withAnimation {
                        let id = UUID()
                        let todo = Todo(
                            id: id,
                            createdAt: Date()
                        )
                        modelContext.insert(todo)
                        focusedTodo = id
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle(menu?.text ?? "")
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
    }
}
