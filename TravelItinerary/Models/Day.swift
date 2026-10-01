import Foundation
import SwiftData

/// A single day within a trip, holding that day's activities.
@Model
nonisolated final class Day {
    var date: Date
    var number: Int
    var trip: Trip?

    @Relationship(deleteRule: .cascade, inverse: \Activity.day)
    var activities: [Activity]

    /// Activities sorted by `sortIndex`.
    var ordered: [Activity] {
        activities.sorted { $0.sortIndex < $1.sortIndex }
    }

    /// Sendable snapshots of the day's activities that have a valid location, in order.
    var mappableStops: [StopSnapshot] {
        ordered.compactMap { $0.snapshot() }
    }

    init(date: Date, number: Int, activities: [Activity] = []) {
        self.date = date
        self.number = number
        self.activities = activities
    }
}
