import SwiftUI

struct MenuView: View {
    
    let menus: [Menu] = .menus
    @Binding var selectedMenu: Menu?
    
    var body: some View {
        List(selection: $selectedMenu) {
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
    }
}
