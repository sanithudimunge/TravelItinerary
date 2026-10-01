import Foundation
import Observation

/// Tracks the signed-in user and whether admin mode is unlocked.
@Observable
final class SessionStore {
    var currentUser: User?
    var isAdmin: Bool = false
    private(set) var failedAttempts: Int = 0

    /// Unlocks admin mode if the PIN matches; otherwise records a failed attempt.
    func unlockAdmin(pin: String) throws(ItineraryError) {
        fatalError("TODO")
    }

    /// Leaves admin mode.
    func lock() {
    }
}
