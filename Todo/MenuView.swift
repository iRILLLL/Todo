import SwiftUI

struct MenuView: View {
    
    let menus: [Menu] = .menus
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(menus, id: \.self) { menu in
                        NavigationLink(destination: TodoListView(menu: menu)) {
                            Label(menu.text, systemImage: menu.icon)
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
