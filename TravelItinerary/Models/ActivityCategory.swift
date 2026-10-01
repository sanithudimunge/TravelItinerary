import Foundation

/// The kind of activity or place, used for grouping and iconography.
nonisolated enum ActivityCategory: String, Codable, CaseIterable, Sendable {
    case sight
    case food
    case stay
    case transport
    case entertainment

    /// SF Symbol name representing the category.
    var symbolName: String {
        switch self {
        case .sight: "binoculars"
        case .food: "fork.knife"
        case .stay: "bed.double"
        case .transport: "tram"
        case .entertainment: "theatermasks"
        }
    }
}
