import SwiftUI
import SwiftData

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
            MenuView(context: container.mainContext)
                .modelContainer(container)
        }
    }
}
