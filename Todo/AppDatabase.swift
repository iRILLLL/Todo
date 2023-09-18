import Foundation
import GRDB

final class AppDatabase: ObservableObject {
    
    private let writer: any DatabaseWriter
    
    init() throws {
        
        let fileManager = FileManager.default
        let appSupportURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        let configuration = Configuration()
        let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
        NSLog("Database stored at \(databaseURL.path)")
        let dbPool = try DatabasePool(path: databaseURL.path, configuration: configuration)
        
        self.writer = dbPool
        try migrator.migrate(writer)
        
        try createPlaceholders()
    }
}

private extension AppDatabase {
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.eraseDatabaseOnSchemaChange = true
        migrator.registerMigration("createTodo") { db in
            try db.create(table: "todo", body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("createdAt", .datetime).notNull()
                t.column("completedAt", .datetime)
            })
        }
        
        return migrator
    }
    
    func createPlaceholders() throws {
        try writer.write { db in
            if try Todo.all().isEmpty(db) {
                for i in 0 ..< 10 {
                    let random = Int.random(in: 0 ..< 1000)
                    if i % 2 == 0 {
                        let date = Date.now
                        let randomDate = Int.random(in: 0 ..< 100000)
                        _ = try Todo(
                            name: "placeholder #\(random)",
                            completedAt: date.addingTimeInterval(TimeInterval(randomDate)),
                            createdAt: Date()
                        ).inserted(db)
                    } else {
                        _ = try Todo(
                            name: "placeholder #\(random)",
                            createdAt: Date()
                        ).inserted(db)
                    }
                }
            }
        }
    }
}

extension AppDatabase {
    
    enum OrderBy {
        case name
        case completedDate
    }
    
    func getUncompletedTodos() throws -> [Todo] {
        try writer.read { db in
            return try Todo.all().filterUncompletedTodos().fetchAll(db)
        }
    }
    
    func createTodo(name: String) throws -> Todo {
        try writer.write { db in
            return try Todo(name: name, createdAt: Date()).inserted(db)
        }
    }
    
    func getTodos(orderBy: OrderBy) throws -> [Todo] {
        try writer.read { db in
            switch orderBy {
            case .name:
                return try Todo.all().orderedByName().fetchAll(db)
            case .completedDate:
                return try Todo.all().orderedByCompletedDate().fetchAll(db)
            }
        }
    }
    
    func deleteTodos(ids: [Int64]) async throws {
        try await writer.write { db in
            _ = try Todo.deleteAll(db, ids: ids)
        }
    }
}
