import SwiftUI

enum DayPalette {
    /// Number of distinct day colours in the asset catalog (Day1…Day5).
    static let count = 5

    /// Returns the colour for a 1-based day number, cycling after Day5
    /// (day 6 → Day1, day 7 → Day2, …). Zero and negative values wrap too.
    static func color(forDay day: Int) -> Color {
        // Shift to 0-based, then use a non-negative modulo so any Int maps into 1...count.
        let index = ((day - 1) % count + count) % count + 1
        return Color("Day\(index)")
    }
}
