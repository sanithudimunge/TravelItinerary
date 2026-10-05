import CoreLocation
import Foundation
import MapKit

/// Calculates and caches routes between stops off the main actor.
///
/// Only `StopSnapshot` values (Sendable) are passed in, never SwiftData models,
/// so nothing tied to a `ModelContext` crosses into the actor.
actor RouteService {
    /// Legs already calculated, keyed by their start and end coordinates (see `cacheKey`).
    private var cache: [String: RouteLeg] = [:]

    /// Legs shorter than this straight-line distance are walked; longer ones are driven.
    private let walkingThreshold: CLLocationDistance = 1_500

    /// Builds a route through the given stops in order.
    func route(for stops: [StopSnapshot]) async throws(ItineraryError) -> DayRoute {
        // One leg per pair of consecutive stops: A→B, B→C, …
        let pairs = Array(zip(stops, stops.dropFirst()))
        guard !pairs.isEmpty else { return DayRoute(legs: []) }

        do {
            let legs = try await withThrowingTaskGroup(of: (Int, RouteLeg).self) { group in
                for (index, pair) in pairs.enumerated() {
                    // Each child task waits on MapKit separately. Calls to `leg` hop onto this actor,
                    // but the actor is free again while a request is in flight, so requests overlap.
                    group.addTask {
                        (index, try await self.leg(from: pair.0, to: pair.1))
                    }
                }

                // Tasks finish in any order, so slot each leg back into its original position.
                var ordered = [RouteLeg?](repeating: nil, count: pairs.count)
                for try await (index, leg) in group {
                    ordered[index] = leg
                }
                return ordered.compactMap { $0 }
            }
            return DayRoute(legs: legs)
        } catch let error as ItineraryError {
            throw error
        } catch {
            // The group's error is untyped; anything unexpected still counts as no route.
            throw .routeUnavailable
        }
    }

    /// Calculates (or returns a cached) leg between two stops.
    func leg(from: StopSnapshot, to: StopSnapshot) async throws(ItineraryError) -> RouteLeg {
        let key = cacheKey(from: from, to: to)
        if let cached = cache[key] {
            return cached
        }

        let start = CLLocation(latitude: from.coordinate.latitude, longitude: from.coordinate.longitude)
        let end = CLLocation(latitude: to.coordinate.latitude, longitude: to.coordinate.longitude)
        // Choose the mode from the straight-line distance. Transit isn't an option:
        // MKDirections doesn't return public transport routes.
        let mode: TransportMode = start.distance(from: end) < walkingThreshold ? .walking : .driving

        let request = MKDirections.Request()
        request.source = MKMapItem(location: start, address: nil)
        request.destination = MKMapItem(location: end, address: nil)
        request.transportType = mode == .walking ? .walking : .automobile

        let response: MKDirections.Response
        do {
            response = try await MKDirections(request: request).calculate()
        } catch {
            // Network errors, no route found, throttling, etc. all mean the same thing to the user.
            throw .routeUnavailable
        }
        guard let route = response.routes.first else {
            throw .routeUnavailable
        }

        let leg = RouteLeg(from: from, to: to, mode: mode, route: route)
        cache[key] = leg
        return leg
    }

    /// A key for one direction of travel, e.g. "6.9166,79.8564->6.9255,79.8450".
    /// A→B and B→A are cached separately because routes can differ (one-way streets).
    private func cacheKey(from: StopSnapshot, to: StopSnapshot) -> String {
        "\(from.coordinate.latitude),\(from.coordinate.longitude)->\(to.coordinate.latitude),\(to.coordinate.longitude)"
    }
}
