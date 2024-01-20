import SwiftData
import Foundation

@Model
public final class TodoGroup {
    
    public var name: String
    public var deletable: Bool = true
    public var renamable: Bool = true
    public var iconName: String?
    
    @Relationship(deleteRule: .cascade, inverse: \Todo.group)
    public var todos: [Todo] = []
    
    public init(name: String) {
        self.name = name
    }
    
    private init(
        name: String,
        deletable: Bool,
        renamable: Bool,
        iconName: String?
    ) {
        self.name = name
        self.deletable = deletable
        self.renamable = renamable
        self.iconName = iconName
    }
    
    @Transient
    public static let today = TodoGroup(name: "Today", deletable: false, renamable: false, iconName: "sun.max")
    
    @Transient
    public static let important = TodoGroup(name: "Important", deletable: false, renamable: false, iconName: "star")
}
