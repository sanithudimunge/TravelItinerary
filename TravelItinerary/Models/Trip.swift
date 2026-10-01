import Foundation
import SwiftData

/// A planned journey owned by a user, made up of an ordered set of days.
@Model
nonisolated final class Trip {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var owner: User?

    @Relationship(deleteRule: .cascade)
    var days: [Day]

    /// Number of calendar days the trip spans.
    var dayCount: Int {
        fatalError("TODO")
    }

    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date, owner: User? = nil, days: [Day] = []) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.owner = owner
        self.days = days
    }
}
