import SwiftUI

struct MenuView: View {
    
    let menus: [Menu] = .menus
    
    var body: some View {
        NavigationStack {
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
                TodoListView(menu: menu)
            }
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(todo: todo)
            }
        }
    }
}
