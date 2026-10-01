import Foundation
import SwiftData

/// A single day within a trip, holding that day's activities.
@Model
nonisolated final class Day {
    var date: Date
    var number: Int

    @Relationship(deleteRule: .cascade)
    var activities: [Activity]

    /// Activities sorted by `sortIndex`.
    var ordered: [Activity] {
        fatalError("TODO")
    }

    /// Sendable snapshots of the day's activities that have a valid location, in order.
    var mappableStops: [StopSnapshot] {
        fatalError("TODO")
    }

    init(date: Date, number: Int, activities: [Activity] = []) {
        self.date = date
        self.number = number
        self.activities = activities
    }
}
