import Foundation
import Observation

/// Drives the itinerary screen: selected day, its route, and editing actions.
@Observable
@MainActor
final class ItineraryViewModel {
    var trip: Trip
    var selectedDay: Day?
    var route: DayRoute?
    var errorMessage: String?

    init(trip: Trip) {
        self.trip = trip
        self.selectedDay = trip.orderedDays.first
    }

    /// Calculates the route for the selected day.
    func loadRoute() async {
    }

    /// Validates and adds an activity to a day.
    func add(_ activity: Activity, to day: Day) throws(ItineraryError) {
        try activity.validate()
        // New activities go to the end of the day.
        activity.sortIndex = (day.activities.map(\.sortIndex).max() ?? -1) + 1
        day.activities.append(activity)
    }

    /// Reorders activities in the selected day.
    func move(from source: IndexSet, to destination: Int) {
    }
}
