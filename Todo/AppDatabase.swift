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
        
        migrator.registerMigration("createTodo") { db in
            try db.create(table: "todo", body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
            })
        }
        
        return migrator
    }
    
    func createPlaceholders() throws {
        try writer.write { db in
            if try Todo.all().isEmpty(db) {
                for i in 0 ..< 5 {
                    _ = try Todo(name: "placeholder #\(i)").inserted(db)
                }
            }
        }
    }
}

extension AppDatabase {
    
    func getTodos() throws -> [Todo] {
        try writer.read{ db in
            try Todo.all().fetchAll(db)
        }
    }
    
    func deleteTodos(ids: [Int64]) async throws {
        try await writer.write { db in
            _ = try Todo.deleteAll(db, ids: ids)
        }
    }
}
