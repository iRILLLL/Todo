import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var database: AppDatabase
    
    @State private var todos: [Todo] = []
    @State private var errorMessage: String?
    
    @Binding var selectedTodo: Todo?
    let menu: Menu?
    
    var body: some View {
        if menu != nil {
            ZStack {
                List(selection: $selectedTodo) {
                    ForEach($todos, id: \.self) { $todo in
                        NavigationLink(value: todo) {
                            TodoItemView(todo: $todo)
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
                .navigationTitle("Todos")
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
        } else {
            Text("Select a menu")
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
