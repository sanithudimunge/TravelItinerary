import SwiftData
import SwiftUI

/// Lists the user's trips.
struct TripListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.startDate) private var trips: [Trip]
    @State private var isAddingTrip = false

    var body: some View {
        NavigationStack {
            Group {
                if trips.isEmpty {
                    ContentUnavailableView {
                        Label("No Trips", systemImage: "suitcase")
                    } description: {
                        Text("Plan your first trip to get started.")
                    } actions: {
                        Button("New Trip") { isAddingTrip = true }
                    }
                } else {
                    List {
                        ForEach(trips) { trip in
                            NavigationLink(value: trip) {
                                TripRow(trip: trip)
                            }
                        }
                        .onDelete(perform: deleteTrips)
                    }
                }
            }
            .navigationTitle("Trips")
            .navigationDestination(for: Trip.self) { trip in
                ItineraryView(trip: trip)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Trip", systemImage: "plus") { isAddingTrip = true }
                }
            }
            .sheet(isPresented: $isAddingTrip) {
                NewTripView()
            }
        }
    }

    private func deleteTrips(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }
}

/// A row summarising a trip's title, dates and length.
private struct TripRow: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trip.title)
                .font(.headline)
            Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) – \(trip.endDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("^[\(trip.dayCount) day](inflect: true)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview(traits: .sampleData) {
    TripListView()
}

#Preview("No Trips") {
    TripListView()
        .modelContainer(for: Trip.self, inMemory: true)
}
