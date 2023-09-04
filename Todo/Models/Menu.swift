import Foundation

struct Menu: Identifiable, Hashable {
    let id: UUID
    let icon: String
    let text: String
}

extension Array where Element == Menu {
    static var menus: [Menu] {
        return [
            .init(id: UUID(), icon: "sun.max", text: "Today"),
            .init(id: UUID(), icon: "archivebox", text: "Completed")
        ]
    }
}
