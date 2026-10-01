import SwiftUI

/// A coloured chip identifying a day.
struct DayChip: View {
    let day: Day
    let isSelected: Bool

    var body: some View {
        let tint = DayPalette.color(forDay: day.number)

        VStack(spacing: 2) {
            Text("Day \(day.number)")
                .font(.subheadline.weight(.semibold))
            Text(day.date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.caption)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        // The system background contrasts with the day colour in both light and dark mode.
        .foregroundStyle(isSelected ? Color(.systemBackground) : tint)
        .background(isSelected ? tint : tint.opacity(0.15), in: Capsule())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
