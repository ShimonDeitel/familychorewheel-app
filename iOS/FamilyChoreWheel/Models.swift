import Foundation

struct Chore: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var assignedTo: String
    var note: String
    var date: Date = Date()
}
