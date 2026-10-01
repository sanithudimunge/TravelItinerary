import CoreLocation
import Foundation
import SwiftData

/// Something scheduled on a day, optionally tied to a place on the map.
@Model
nonisolated final class Activity: Mappable {
    var title: String
    var category: ActivityCategory
    var start: Date
    var end: Date?
    var notes: String
    var sortIndex: Int
    var place: Place?

    var name: String {
        fatalError("TODO")
    }

    var coordinate: CLLocationCoordinate2D? {
        fatalError("TODO")
    }

    init(title: String, category: ActivityCategory, start: Date, end: Date? = nil, notes: String = "", sortIndex: Int = 0, place: Place? = nil) {
        self.title = title
        self.category = category
        self.start = start
        self.end = end
        self.notes = notes
        self.sortIndex = sortIndex
        self.place = place
    }

    /// A Sendable copy suitable for routing, or `nil` if the activity has no location.
    func snapshot() -> StopSnapshot? {
        fatalError("TODO")
    }

    /// Checks the activity is consistent (e.g. end after start, has a location).
    func validate() throws(ItineraryError) {
        fatalError("TODO")
    }
}
