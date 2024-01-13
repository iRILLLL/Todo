import SwiftUI
import TodoInterface

struct SidebarView: View {
    
    @Binding var selection: SidebarMenu?
    
    var body: some View {
        List(selection: $selection) {
            Section {
                NavigationLink(value: SidebarMenu.today) {
                    Label(
                        SidebarMenu.today.text,
                        systemImage: SidebarMenu.today.icon
                    )
                }
                
                NavigationLink(value: SidebarMenu.important) {
                    Label(
                        SidebarMenu.important.text,
                        systemImage: SidebarMenu.important.icon
                    )
                }
            }
        }
    }
}
