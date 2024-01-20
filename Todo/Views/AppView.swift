import SwiftUI
import SwiftData
import TodoUI
import TodoInterface
import os

struct AppView: View {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @State private var navPath = NavigationPath()
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            
//            NavigationSplitView {
//                SidebarView(selection: $selection)
//            } detail: {
//                TodoListView(
//                    modelContext: modelContext,
//                    navPath: $navPath,
//                    group: <#TodoGroup#>
//                )
//                .id(selection?.hashValue) // work around https://forums.developer.apple.com/forums/thread/707924
//            }

        } else {
            SidebarView(modelContext: modelContext, navPath: $navPath)
        }
    }
}
