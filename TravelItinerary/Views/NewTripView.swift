import SwiftData
import SwiftUI

/// Creates a new trip and generates one day per date in its range.
struct NewTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var startDate = Calendar.current.startOfDay(for: .now)
    @State private var endDate = Calendar.current.startOfDay(for: .now)
    @State private var errorMessage: String?

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                // The picker's range is the first safeguard against an end date before the start date.
                // Trip.validateDates in save() is a second one that keeps the rule in the model.
                DatePicker("Ends", selection: $endDate, in: startDate..., displayedComponents: .date)

                if let errorMessage {
                    Section {
                        InlineError(message: errorMessage)
                    }
                }
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
        do throws(ItineraryError) {
            try Trip.validateDates(start: startDate, end: endDate)
            let trip = Trip(title: trimmedTitle, startDate: startDate, endDate: endDate)
            modelContext.insert(trip)
            trip.generateDays()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview(traits: .sampleData) {
    NewTripView()
}
