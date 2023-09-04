import SwiftUI

@main
struct TodoApp: App {
    
    @StateObject var database = try! AppDatabase()
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(database)
        }
    }
}
