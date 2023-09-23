import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject private var database: AppDatabase
    
    @State private var todos: [Todo] = []
    @State private var errorMessage: String?
    
    @FocusState private var focusedTodo: Int64?
    
    let menu: Menu
    @Binding var navPath: NavigationPath
    
    var body: some View {
        List {
            ForEach($todos, id: \.self) { $todo in
                Button {
                    navPath.append(todo)
                } label: {
                    TodoItemView(todo: .init(
                        get: { todo },
                        set: { mutatedTodo in
                            let isToggleChanged = mutatedTodo.isCompleted != todo.isCompleted
                            if isToggleChanged {
                                do {
                                    try database.toggleCompletedTodo(&todo)
                                } catch {
                                    print(error)
                                }
                                getTodos()
                            }
                        }
                    ))
                        .focused($focusedTodo, equals: todo.id)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                guard let id = todo.id else { return }
                                Task {
                                    try? await database.deleteTodos(ids: [id])
                                }
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
                        do {
                            let todo = try database.createTodo(name: "Todo")
                            todos.insert(todo, at: 0)
                            focusedTodo = todo.id
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Todos")
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
        .onAppear {
            getTodos()
        }
    }
    
    private func getTodos() {
        do {
            todos = try database.getTodos(orderBy: .completedDate)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct HideCaratButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
