import Foundation

/// Errors raised while editing itineraries, routing, or unlocking admin mode.
nonisolated enum ItineraryError: Error {
    case invalidDateRange
    case endBeforeStart
    case missingLocation(String)
    case routeUnavailable
    case incorrectPIN(attemptsLeft: Int)
}
