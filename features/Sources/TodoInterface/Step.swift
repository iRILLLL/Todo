import SwiftData
import Foundation

@Model
public final class Step {
    
    @Attribute(.unique)
    public var id: UUID
    
    public var name: String
    
    public init(
        id: UUID,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
