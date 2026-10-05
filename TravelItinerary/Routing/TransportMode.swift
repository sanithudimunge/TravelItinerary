import Foundation

/// How a traveller gets from one stop to the next.
/// Transit is omitted because `MKDirections.calculate()` doesn't return public transport routes.
nonisolated enum TransportMode: String, Codable, CaseIterable, Sendable {
    case walking
    case driving

    /// SF Symbol name representing the mode.
    var symbolName: String {
        switch self {
        case .walking: "figure.walk"
        case .driving: "car.fill"
        }
    }
}
