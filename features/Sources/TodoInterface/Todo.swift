import SwiftData
import Foundation

@Model
public final class Todo {
    
    @Attribute(.unique) 
    public var id: UUID
    
    public var name: String
    public var isImportant: Bool
    
    @Attribute(originalName: "completed_at")
    public var completedAt: Date?
    
    @Attribute(originalName: "due_at")
    public var dueAt: Date?
    
    @Attribute(originalName: "created_at")
    public var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    public var steps: [Step]?
    
    @Transient
    public var isCompleted: Bool {
        completedAt != nil
    }
    
    public init(
        id: UUID,
        name: String = "",
        isImportant: Bool = false,
        completedAt: Date? = nil,
        dueAt: Date? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.isImportant = isImportant
        self.completedAt = completedAt
        self.dueAt = dueAt
        self.createdAt = createdAt
    }
}

//import GRDB
//import Foundation
//
//struct Todo: Identifiable, Hashable {
//    var id: Int64?
//    var name: String
//    var completedAt: Date?
//    var createdAt: Date
//    var isImportant: Bool
//    
//    var isCompleted: Bool {
//        get { completedAt != nil }
//        set { completedAt = newValue ? Date() : nil }
//    }
//}
//
//extension Todo: Codable, FetchableRecord, MutablePersistableRecord {
//    
//    fileprivate enum Columns {
//        static let name = Column(CodingKeys.name)
//        static let completedAt = Column(CodingKeys.completedAt)
//        static let createdAt = Column(CodingKeys.createdAt)
//        static let isImportant = Column(CodingKeys.isImportant)
//    }
//    
//    mutating func didInsert(_ inserted: InsertionSuccess) {
//        self.id = inserted.rowID
//    }
//}
//
//extension DerivableRequest<Todo> {
//    
//    func filterUncompletedTodos() -> Self {
//        filter(sql: "completedAt is null")
//    }
//    
//    func orderedByName() -> Self {
//        order(Todo.Columns.name.collating(.localizedCaseInsensitiveCompare))
//    }
//    
//    func orderedByCompletedDate() -> Self {
//        order(Todo.Columns.completedAt.asc, Todo.Columns.createdAt.desc)
//    }
//}
