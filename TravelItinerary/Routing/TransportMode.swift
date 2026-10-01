import Foundation

/// How a traveller gets from one stop to the next.
/// Transit is omitted because `MKDirections.calculate()` doesn't return public transport routes.
nonisolated enum TransportMode: String, Codable, CaseIterable, Sendable {
    case walking
    case driving
}
