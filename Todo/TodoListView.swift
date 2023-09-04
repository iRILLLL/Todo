import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var database: AppDatabase
    
    @State private var todos: [Todo] = []
    @State private var errorMessage: String?
    
    let menu: Menu
    
    var body: some View {
        NavigationView {
            if let errorMessage {
                Text(errorMessage)
            } else {
                List {
                    ForEach(todos) { todo in
                        Text(todo.name)
                    }
                    .onDelete { indexSet in
                        let ids = indexSet.compactMap { todos[$0].id }
                        Task {
                            try? await database.deleteTodos(ids: ids)
                        }
                    }
                }
            }
        }
        .onAppear {
            getTodos()
        }
    }
    
    private func getTodos() {
        do {
            todos = try database.getTodos()
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
