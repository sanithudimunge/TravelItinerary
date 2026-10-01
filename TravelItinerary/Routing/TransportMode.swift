import Foundation

/// How a traveller gets from one stop to the next.
nonisolated enum TransportMode: String, Codable, CaseIterable, Sendable {
    case walking
    case driving
    case transit
}
