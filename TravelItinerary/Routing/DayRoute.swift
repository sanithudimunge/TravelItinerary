import CoreLocation
import Foundation

/// The full route for a day: every leg plus aggregate time and distance.
nonisolated struct DayRoute: Sendable {
    let legs: [RouteLeg]
    let totalTime: TimeInterval
    let totalDistance: CLLocationDistance
}
