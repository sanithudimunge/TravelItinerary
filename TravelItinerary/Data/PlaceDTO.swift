import Foundation

/// Raw place data decoded from seed JSON, before validation.
struct PlaceDTO: Decodable {
    let name: String?
    let lat: Double
    let lon: Double
    let category: String
    let address: String?

    /// Converts the decoded data into a `Place` model.
    func makeModel() -> Place {
        fatalError("TODO")
    }
}
