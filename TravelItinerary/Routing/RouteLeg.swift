import CoreLocation
import Foundation
import MapKit

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

extension RouteLeg {
    /// Copies what the app needs out of an `MKRoute`, so only Sendable values are kept.
    nonisolated init(from: StopSnapshot, to: StopSnapshot, mode: TransportMode, route: MKRoute) {
        // MKPolyline stores its points in a C buffer; copy them into a Swift array.
        let polyline = route.polyline
        var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: polyline.pointCount)
        polyline.getCoordinates(&coordinates, range: NSRange(location: 0, length: polyline.pointCount))

        self.init(
            from: from,
            to: to,
            travelTime: route.expectedTravelTime,
            distance: route.distance,
            mode: mode,
            path: coordinates
        )
    }
}
