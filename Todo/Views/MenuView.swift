import SwiftUI
import SwiftData
import TodoUI
import TodoInterface
import os

struct MenuView: View {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @State private var navPath = NavigationPath()
    @State private var selection: SidebarMenu? = .today
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            
            NavigationSplitView {
                SidebarView(selection: $selection)
            } detail: {
                TodoListView(
                    modelContext: modelContext,
                    navPath: $navPath,
                    sidebarMenu: selection
                )
                .id(selection?.hashValue) // work around https://forums.developer.apple.com/forums/thread/707924
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
                .navigationDestination(for: SidebarMenu.self) { sidebarMenu in
                    TodoListView(
                        modelContext: modelContext,
                        navPath: $navPath,
                        sidebarMenu: sidebarMenu
                    )
                }
                .navigationDestination(for: Todo.self) { todo in
                    TodoDetailView(todo: todo)
                }
            }
        }
    }
}
