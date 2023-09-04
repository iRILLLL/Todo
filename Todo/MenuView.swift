import SwiftUI

struct MenuView: View {
    
    let menus: [Menu] = .menus
    
    var body: some View {
        List {
            Section {
                ForEach(menus) { menu in
                    Label(menu.text, systemImage: menu.icon)
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
