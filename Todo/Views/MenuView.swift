import SwiftUI
import SwiftData
import TodoUI
import TodoInterface
import os

struct MenuView: View {
    
    @State private var navPath = NavigationPath()
    @State private var selection: SidebarMenu? = .today
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            
            NavigationSplitView {
                SidebarView(selection: $selection)
            } detail: {
                TodoListView(
                    navPath: $navPath,
                    menu: selection
                )
            }

            
        } else {
            NavigationStack(path: $navPath) {
                List() {
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
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: SidebarMenu.self) { menu in
                    TodoListView(
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
}
