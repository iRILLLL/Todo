import GRDB
import Foundation

struct Todo: Identifiable, Hashable {
    var id: Int64?
    var name: String
    var completedAt: Date?
    
    var isCompleted: Bool {
        get { completedAt != nil }
        set { completedAt = newValue ? Date() : nil }
    }
}

extension Todo: Codable, FetchableRecord, MutablePersistableRecord {
    
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
        static let completedAt = Column(CodingKeys.completedAt)
    }
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }
}

extension DerivableRequest<Todo> {
    
    func filterUncompletedTodos() -> Self {
        filter(sql: "completedAt is null")
    }
    
    func orderedByName() -> Self {
        order(Todo.Columns.name.collating(.localizedCaseInsensitiveCompare))
    }
    
    func orderedByCompletedDate() -> Self {
        order(Todo.Columns.completedAt.collating(.localizedCaseInsensitiveCompare))
    }
}
