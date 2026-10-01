import Foundation

/// Raw place data decoded from seed JSON, before validation.
struct PlaceDTO: Decodable {
    let name: String?
    let lat: Double
    let lon: Double
    let category: String
    let address: String?

    /// Converts the decoded data into a `Place` model.
    /// Missing names and unknown categories get fallbacks so the place can still be reviewed by an admin.
    func makeModel() -> Place {
        Place(
            name: name ?? "Unnamed place",
            latitude: lat,
            longitude: lon,
            category: ActivityCategory(rawValue: category) ?? .sight,
            address: address
        )
    }
}
