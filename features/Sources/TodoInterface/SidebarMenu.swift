import Foundation

public enum SidebarMenu: Hashable {
    case today
    case important
}

extension SidebarMenu {
    
    public var icon: String {
        switch self {
        case .today: "sun.max"
        case .important: "star"
        }
    }
    
    public var text: String {
        switch self {
        case .today: "Today"
        case .important: "Important"
        }
    }
}
