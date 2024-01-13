import Foundation

public struct Menu: Identifiable, Hashable {
    public let id: UUID
    public let icon: String
    public let text: String
}

extension Array where Element == Menu {
    public static var menus: [Menu] {
        return [
            .init(id: UUID(), icon: "sun.max", text: "Today"),
            .init(id: UUID(), icon: "star", text: "Important")
        ]
    }
}
