import SwiftData
import SwiftUI

/// Gives SwiftUI previews an in-memory store filled with the app's seed data.
struct SampleData: PreviewModifier {
    /// Builds the store once and shares it between every preview that uses the `.sampleData` trait.
    static func makeSharedContext() async throws -> ModelContainer {
        let schema = Schema([
            Trip.self,
            Day.self,
            Activity.self,
            Place.self,
            User.self,
        ])
        // In memory only, so previews never touch the app's real data.
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        try SeedLoader().loadIfNeeded(into: container.mainContext)
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    /// Use with `#Preview(traits: .sampleData)` to preview with the seeded places and sample trip.
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
