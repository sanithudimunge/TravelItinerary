import SwiftUI

/// A map annotation marking a stop.
struct StopAnnotationView: View {
    /// The stop's 1-based position in the day.
    let number: Int
    /// The day's colour from `DayPalette`.
    let color: Color

    var body: some View {
        Text("\(number)")
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(color, in: Circle())
            // A white ring keeps the pin visible against any map colour.
            .overlay(Circle().stroke(.white, lineWidth: 2))
            .shadow(radius: 2)
            .accessibilityLabel("Stop \(number)")
    }
}

#Preview {
    HStack {
        ForEach(1...5, id: \.self) { day in
            StopAnnotationView(number: day, color: DayPalette.color(forDay: day))
        }
    }
    .padding()
}
