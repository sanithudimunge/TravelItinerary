import Foundation

/// The permission level of a user.
nonisolated enum UserRole: String, Codable, Sendable {
    case traveller
    case admin
}
