import SwiftData
import SwiftUI

/// Shows a trip's days and the selected day's activities.
struct ItineraryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ItineraryViewModel

    init(trip: Trip) {
        _viewModel = State(initialValue: ItineraryViewModel(trip: trip))
    }

    var body: some View {
        List {
            Section {
                dayPicker
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            if let day = viewModel.selectedDay {
                activitiesSection(for: day)
            }
        }
        .navigationTitle(viewModel.trip.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var dayPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.trip.orderedDays) { day in
                    Button {
                        viewModel.selectedDay = day
                    } label: {
                        DayChip(day: day, isSelected: day == viewModel.selectedDay)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private func activitiesSection(for day: Day) -> some View {
        let activities = day.ordered
        Section(day.date.formatted(date: .complete, time: .omitted)) {
            if activities.isEmpty {
                ContentUnavailableView(
                    "No Activities",
                    systemImage: "calendar.badge.plus",
                    description: Text("Nothing planned for day \(day.number) yet.")
                )
            } else {
                ForEach(activities) { activity in
                    ActivityRow(activity: activity)
                }
                .onDelete { offsets in
                    delete(offsets.map { activities[$0] }, from: day)
                }
            }
        }
    }

    private func delete(_ activities: [Activity], from day: Day) {
        for activity in activities {
            // Remove from the relationship first so the list updates before the context saves.
            day.activities.removeAll { $0 == activity }
            modelContext.delete(activity)
        }
    }
}
