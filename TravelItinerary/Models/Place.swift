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

    /// The place's coordinate, or `nil` if latitude/longitude are out of range.
    var coordinate: CLLocationCoordinate2D? {
        fatalError("TODO")
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
