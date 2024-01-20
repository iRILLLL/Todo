import SwiftUI
import TodoInterface
import TodoUI
import SwiftData

struct SidebarView: View {
    
    @State private var viewModel: ViewModel
    @Binding private var navPath: NavigationPath
    
    public init(
        modelContext: ModelContext,
        navPath: Binding<NavigationPath>
    ) {
        _viewModel = State(
            initialValue: ViewModel(
                modelContext: modelContext
            )
        )
        _navPath = navPath
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List() {
                Section {
                    NavigationLink(value: TodoGroup.today) {
                        Label(
                            TodoGroup.today.name,
                            systemImage: TodoGroup.today.iconName!
                        )
                    }
                    
                    NavigationLink(value: TodoGroup.important) {
                        Label(
                            TodoGroup.important.name,
                            systemImage: TodoGroup.important.iconName!
                        )
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: TodoGroup.self) { group in
                TodoListView(
                    modelContext: viewModel.modelContext,
                    navPath: $navPath,
                    group: group
                )
            }
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(todo: todo)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Group")
                        }
                    }
                }
            }
        }
    }
}

extension SidebarView {
    
    @Observable
    final class ViewModel {
        
        fileprivate let modelContext: ModelContext
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
    }
}
