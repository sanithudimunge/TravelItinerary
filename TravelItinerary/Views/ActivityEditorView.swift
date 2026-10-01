import SwiftData
import SwiftUI

/// Creates or edits an activity.
struct ActivityEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Place.name) private var places: [Place]

    let day: Day
    /// The activity being edited, or `nil` when creating a new one.
    let activity: Activity?
    let viewModel: ItineraryViewModel

    // Draft values. They're only written to the model after validation passes.
    @State private var title: String
    @State private var category: ActivityCategory
    @State private var start: Date
    @State private var hasEnd: Bool
    @State private var end: Date
    @State private var notes: String
    @State private var place: Place?
    @State private var errorMessage: String?

    init(day: Day, activity: Activity? = nil, viewModel: ItineraryViewModel) {
        self.day = day
        self.activity = activity
        self.viewModel = viewModel

        let defaultStart = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: day.date) ?? day.date
        let start = activity?.start ?? defaultStart
        _title = State(initialValue: activity?.title ?? "")
        _category = State(initialValue: activity?.category ?? .sight)
        _start = State(initialValue: start)
        _hasEnd = State(initialValue: activity == nil || activity?.end != nil)
        _end = State(initialValue: activity?.end ?? start.addingTimeInterval(3600))
        _notes = State(initialValue: activity?.notes ?? "")
        _place = State(initialValue: activity?.place)
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(ActivityCategory.allCases, id: \.self) { category in
                            Label(category.rawValue.capitalized, systemImage: category.symbolName)
                                .tag(category)
                        }
                    }
                }

                Section("Time") {
                    DatePicker("Starts", selection: $start, displayedComponents: .hourAndMinute)
                    Toggle("End Time", isOn: $hasEnd)
                    if hasEnd {
                        DatePicker("Ends", selection: $end, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Location") {
                    Picker("Place", selection: $place) {
                        Text("None").tag(Place?.none)
                        ForEach(places) { place in
                            Text(place.name).tag(Optional(place))
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let errorMessage {
                    Section {
                        InlineError(message: errorMessage)
                    }
                }
            }
            .navigationTitle(activity == nil ? "New Activity" : "Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: place) { _, newPlace in
                // Default the category to the chosen place's category for new activities.
                if activity == nil, let newPlace {
                    category = newPlace.category
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
        let endTime = hasEnd ? end : nil
        do throws(ItineraryError) {
            try Activity.validate(title: trimmedTitle, start: start, end: endTime, place: place)

            if let activity {
                activity.title = trimmedTitle
                activity.category = category
                activity.start = start
                activity.end = endTime
                activity.notes = notes
                activity.place = place
            } else {
                let newActivity = Activity(title: trimmedTitle, category: category, start: start, end: endTime, notes: notes, place: place)
                try viewModel.add(newActivity, to: day)
            }
            dismiss()
        } catch {
            // `error` is an ItineraryError here thanks to the typed `do throws`.
            errorMessage = error.localizedDescription
        }
    }
}
