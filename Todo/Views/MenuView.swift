import SwiftUI
import SwiftData
import TodoUI
import TodoInterface

struct MenuView: View {
    
    let menus: [TodoInterface.Menu] = .menus
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List() {
                Section {
                    ForEach(menus, id: \.self) { menu in
                        NavigationLink(value: menu) {
                            Label(menu.text, systemImage: menu.icon)
                        }
                    }
                    .onMove { (source: IndexSet, dest: Int) in
                        
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Menu.self) { menu in
                TodoListView(
                    context: self.context,
                    navPath: $navPath,
                    menu: menu
                )
            }
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(todo: todo)
            }
        }
    }
}
