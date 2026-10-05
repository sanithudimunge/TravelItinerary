import Foundation
import Observation
// Needed for `Array.move(fromOffsets:toOffset:)`, which SwiftUI provides.
import SwiftUI

/// Drives the itinerary screen: selected day, its route, and editing actions.
@Observable
@MainActor
final class ItineraryViewModel {
    var trip: Trip
    var selectedDay: Day?
    var route: DayRoute?
    var errorMessage: String?

    /// Shared so its leg cache survives switching between days.
    private let routeService = RouteService()

    init(trip: Trip) {
        self.trip = trip
        self.selectedDay = trip.orderedDays.first
    }

    /// Calculates the route for the selected day.
    func loadRoute() async {
        guard let day = selectedDay else {
            route = nil
            return
        }
        // Snapshots are taken here on the main actor; only these Sendable copies go to the service.
        let stops = day.mappableStops
        do throws(ItineraryError) {
            route = try await routeService.route(for: stops)
            errorMessage = nil
        } catch {
            route = nil
            errorMessage = error.localizedDescription
        }
    }

    /// Validates and adds an activity to a day.
    func add(_ activity: Activity, to day: Day) throws(ItineraryError) {
        try activity.validate()
        // New activities go to the end of the day.
        activity.sortIndex = (day.activities.map(\.sortIndex).max() ?? -1) + 1
        day.activities.append(activity)
    }

    /// Reorders activities in the selected day.
    ///
    /// `source` and `destination` are positions in `day.ordered`, which is what the list shows.
    func move(from source: IndexSet, to destination: Int) {
        guard let day = selectedDay else { return }
        var reordered = day.ordered
        reordered.move(fromOffsets: source, toOffset: destination)
        // Renumber from 0 so `sortIndex` matches the new order. This also closes any gaps left by deletions.
        for (index, activity) in reordered.enumerated() {
            activity.sortIndex = index
        }
    }
}
