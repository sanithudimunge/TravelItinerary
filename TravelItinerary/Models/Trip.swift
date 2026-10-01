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

    @Relationship(deleteRule: .cascade, inverse: \Day.trip)
    var days: [Day]

    /// Number of calendar days the trip spans, counting both the first and last day.
    var dayCount: Int {
        // Compare start-of-day values so the times of day don't change the count.
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        return (calendar.dateComponents([.day], from: start, to: end).day ?? 0) + 1
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
