import CoreLocation

/// Anything that can be shown on a map by name and (optional) coordinate.
nonisolated protocol Mappable {
    var name: String { get }
    var coordinate: CLLocationCoordinate2D? { get }
}

nonisolated extension Mappable {
    /// Whether the item has a usable coordinate.
    var hasLocation: Bool {
        coordinate != nil
    }
}
