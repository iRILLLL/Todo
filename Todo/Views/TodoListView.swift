import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var database: AppDatabase
    
    @State private var todos: [Todo] = []
    @State private var errorMessage: String?
    
    let menu: Menu
    
    var body: some View {
        List {
            ForEach($todos) { todo in
                TodoItemView(todo: todo)
            }
            .onDelete { indexSet in
                let ids = indexSet.compactMap { todos[$0].id }
                Task {
                    try? await database.deleteTodos(ids: ids)
                }
            }
        }
        .onAppear {
            getTodos()
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
