import CoreLocation
import Foundation
import SwiftData

/// A real-world location that activities can be attached to.
@Model
nonisolated final class Place: Mappable {
    var name: String
    var latitude: Double
    var longitude: Double
    var category: ActivityCategory
    var isVerified: Bool
    var address: String?

    /// Activities at this place. Deleting the place sets their `place` to `nil`.
    @Relationship(deleteRule: .nullify, inverse: \Activity.place)
    var activities: [Activity] = []

    /// The place's coordinate, or `nil` if latitude/longitude are out of range.
    var coordinate: CLLocationCoordinate2D? {
        guard (-90...90).contains(latitude), (-180...180).contains(longitude) else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Human-readable data-quality problems with this place.
    var issues: [String] {
        fatalError("TODO")
    }

    init(name: String, latitude: Double, longitude: Double, category: ActivityCategory, isVerified: Bool = false, address: String? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.isVerified = isVerified
        self.address = address
    }
}
