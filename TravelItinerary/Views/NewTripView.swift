import SwiftData
import SwiftUI

/// Creates a new trip and generates one day per date in its range.
struct NewTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var startDate = Calendar.current.startOfDay(for: .now)
    @State private var endDate = Calendar.current.startOfDay(for: .now)

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                // Limiting the range means the end date can never be before the start date.
                DatePicker("Ends", selection: $endDate, in: startDate..., displayedComponents: .date)
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: startDate) { _, newStart in
                if endDate < newStart {
                    endDate = newStart
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(trimmedTitle.isEmpty)
                }
            }
        }
    }

    private func save() {
        let trip = Trip(title: trimmedTitle, startDate: startDate, endDate: endDate)
        modelContext.insert(trip)
        trip.generateDays()
        dismiss()
    }
}
