import SwiftUI

/// An inline error message shown beneath content.
struct InlineError: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "exclamationmark.circle.fill")
            .font(.footnote)
            .foregroundStyle(Color("Destructive"))
            .accessibilityLabel("Error: \(message)")
    }
}

#Preview {
    InlineError(message: ItineraryError.endBeforeStart.localizedDescription)
        .padding()
}
