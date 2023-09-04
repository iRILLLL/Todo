import GRDB

struct Todo: Identifiable, Hashable {
    var id: Int64?
    var name: String
}

extension Todo: Codable, FetchableRecord, MutablePersistableRecord {
    
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
    }
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }
}
