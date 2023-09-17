import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var database: AppDatabase
    
    @State private var todos: [Todo] = []
    @State private var errorMessage: String?
    @FocusState private var focusedTodo: Int64?
    
    let menu: Menu
    
    var body: some View {
        ZStack {
            List {
                ForEach($todos) { $todo in
                    TodoItemView(todo: $todo)
                        .focused($focusedTodo, equals: todo.id)
                }
                .onDelete { indexSet in
                    let ids = indexSet.compactMap { todos[$0].id }
                    Task {
                        try? await database.deleteTodos(ids: ids)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .listStyle(.plain)
            .onAppear {
                getTodos()
            }
            
            Button(action: {
                withAnimation {
                    do {
                        let todo = try database.createTodo(name: "")
                        todos.insert(todo, at: 0)
                        focusedTodo = todo.id
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.accentColor)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom)
        }
    }
    
    private func getTodos() {
        do {
            todos = try database.getUncompletedTodos()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(menu: [Menu].menus[0])
    }
}
