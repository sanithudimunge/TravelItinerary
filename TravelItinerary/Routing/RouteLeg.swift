import CoreLocation
import Foundation

/// A single journey between two consecutive stops.
nonisolated struct RouteLeg: Sendable, Hashable {
    let from: StopSnapshot
    let to: StopSnapshot
    let travelTime: TimeInterval
    let distance: CLLocationDistance
    let mode: TransportMode
    let path: [CLLocationCoordinate2D]

    // CLLocationCoordinate2D isn't Hashable, so compare the path point by point.
    static func == (lhs: RouteLeg, rhs: RouteLeg) -> Bool {
        lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.travelTime == rhs.travelTime
            && lhs.distance == rhs.distance
            && lhs.mode == rhs.mode
            && lhs.path.count == rhs.path.count
            && zip(lhs.path, rhs.path).allSatisfy { $0.latitude == $1.latitude && $0.longitude == $1.longitude }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(mode)
    }
}
