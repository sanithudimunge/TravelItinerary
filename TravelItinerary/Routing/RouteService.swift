import Foundation

/// Calculates and caches routes between stops off the main actor.
actor RouteService {
    private var cache: [String: RouteLeg] = [:]

    /// Builds a route through the given stops in order.
    func route(for stops: [StopSnapshot]) async throws -> DayRoute {
        fatalError("TODO")
    }

    /// Calculates (or returns a cached) leg between two stops.
    func leg(from: StopSnapshot, to: StopSnapshot) async throws -> RouteLeg {
        fatalError("TODO")
    }
}
