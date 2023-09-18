import SwiftUI

@main
struct TodoApp: App {
    
    @StateObject var database = try! AppDatabase()
    
    @State private var selectedMenu: Menu? = [Menu].menus[0]
    @State private var selectedTodo: Todo?
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                MenuView(selectedMenu: $selectedMenu)
            } content: {
                TodoListView(selectedTodo: $selectedTodo, menu: selectedMenu)
            } detail: {
                TodoDetailView(todo: selectedTodo)
            }
            .environmentObject(database)
        }
    }
}
