import SwiftUI
import SwiftData
import TodoInterface

@main
struct TodoApp: App {
        
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Todo.self, Step.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(modelContext: container.mainContext)
                .modelContainer(container)
        }
    }
}
