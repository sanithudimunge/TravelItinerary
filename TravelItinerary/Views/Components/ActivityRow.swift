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
                Label(place.name, systemImage: "mappin.and.ellipse")
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
