import SwiftData
import SwiftUI

/// A row summarising one activity.
struct ActivityRow: View {
    let activity: Activity

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: activity.category.symbolName)
                .foregroundStyle(Color.accentColor)
                .frame(width: 36, height: 36)
                .background(Color("AccentSoft"), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.headline)
                Text(timeText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                locationLabel
                    .font(.footnote)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }

    private var timeText: String {
        let start = activity.start.formatted(date: .omitted, time: .shortened)
        guard let end = activity.end else { return start }
        return "\(start) – \(end.formatted(date: .omitted, time: .shortened))"
    }

    /// The place name, or a warning when the activity can't be shown on the map.
    @ViewBuilder
    private var locationLabel: some View {
        if let place = activity.place {
            if activity.hasLocation {
                Text(place.name)
                    .foregroundStyle(.secondary)

            } else {
                Label("\(place.name) has an invalid location", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color("Warning"))
            }
        } else {
            Label("No location", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(Color("Warning"))
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var trips: [Trip]
    @Previewable @Query(filter: #Predicate<Place> { $0.name == "Adam's Peak" }) var brokenPlaces: [Place]
    List {
        if let day = trips.first?.orderedDays.first {
            ForEach(day.ordered) { activity in
                ActivityRow(activity: activity)
            }
        }
        // Not inserted into the store; these only show the two warning states.
        ActivityRow(activity: Activity(title: "Free afternoon", category: .entertainment, start: .now))
        ActivityRow(activity: Activity(title: "Climb Adam's Peak", category: .sight, start: .now, place: brokenPlaces.first))
    }
}
