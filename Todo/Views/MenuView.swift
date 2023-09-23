import SwiftUI

struct MenuView: View {
    
    let menus: [Menu] = .menus
    
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
                TodoListView(menu: menu, navPath: $navPath)
            }
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(todo: todo)
            }
        }
    }
}
