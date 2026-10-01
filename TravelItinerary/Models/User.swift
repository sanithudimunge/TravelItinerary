import Foundation
import SwiftData

/// A person using the app, who owns trips and has a role.
@Model
nonisolated final class User {
    var id: UUID
    var displayName: String
    var role: UserRole

    @Relationship(inverse: \Trip.owner)
    var trips: [Trip]

    init(id: UUID = UUID(), displayName: String, role: UserRole = .traveller, trips: [Trip] = []) {
        self.id = id
        self.displayName = displayName
        self.role = role
        self.trips = trips
    }
}
