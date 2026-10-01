import Foundation

/// Stores and checks the admin PIN in the Keychain.
nonisolated struct KeychainStore: Sendable {
    /// Saves a new admin PIN, replacing any existing one.
    func setPIN(_ pin: String) throws {
        fatalError("TODO")
    }

    /// Returns whether the given PIN matches the stored one.
    func verify(_ pin: String) -> Bool {
        fatalError("TODO")
    }
}
