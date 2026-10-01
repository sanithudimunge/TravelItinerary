import CoreLocation

/// A Sendable, immutable copy of a stop that can cross into the routing actor.
nonisolated struct StopSnapshot: Sendable, Hashable {
    let name: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: StopSnapshot, rhs: StopSnapshot) -> Bool {
        lhs.name == rhs.name
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}
