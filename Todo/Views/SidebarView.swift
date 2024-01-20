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
                
                Section(viewModel.groups.count > 1 ? "My Groups" : "My Group") {
                    ForEach(viewModel.groups, id: \.self) { group in
                        NavigationLink(value: group) {
                            if let iconName = group.iconName {
                                Label(
                                    group.name,
                                    systemImage: iconName
                                )
                            } else {
                                Text(group.name)
                            }
                        }
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
                        let newGroup = viewModel.addNewGroup()
                        navPath.append(newGroup)
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
        private(set) var groups: [TodoGroup] = []
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchGroups()
        }
        
        func addNewGroup() -> TodoGroup {
            let group = TodoGroup(name: "New Group")
            modelContext.insert(group)
            fetchGroups()
            return group
        }
        
        func fetchGroups() {
            
            let descriptor = FetchDescriptor<TodoGroup>(
                sortBy: []
            )
            
            do {
                self.groups = try modelContext.fetch(descriptor)
            } catch {
                print(error)
            }
        }
    }
}
