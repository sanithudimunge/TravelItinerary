import CoreLocation
import Foundation

/// The full route for a day: every leg plus aggregate time and distance.
nonisolated struct DayRoute: Sendable {
    let legs: [RouteLeg]
    let totalTime: TimeInterval
    let totalDistance: CLLocationDistance

    /// Builds a route from legs in travel order, summing their time and distance.
    init(legs: [RouteLeg]) {
        self.legs = legs
        self.totalTime = legs.reduce(0) { $0 + $1.travelTime }
        self.totalDistance = legs.reduce(0) { $0 + $1.distance }
    }
}
