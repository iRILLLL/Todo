import SwiftData
import Foundation

@Model
public final class Todo {
    
    @Attribute(.unique) 
    public var id: UUID
    
    public var name: String
    public var isImportant: Bool
    public var group: TodoGroup?
    
    @Attribute(originalName: "completed_at")
    public var completedAt: Date?
    
    @Attribute(originalName: "due_at")
    public var dueAt: Date?
    
    @Attribute(originalName: "created_at")
    public var createdAt: Date
    
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

