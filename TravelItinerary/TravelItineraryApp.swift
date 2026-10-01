//
//  TravelItineraryApp.swift
//  TravelItinerary
//
//  Created by Sanithu on 2026-08-28.
//

import SwiftUI
import SwiftData

@main
struct TravelItineraryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Trip.self,
            Day.self,
            Activity.self,
            Place.self,
            User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        // Missing seed data shouldn't stop the app from launching, so log and carry on.
        do {
            try SeedLoader().loadIfNeeded(into: container.mainContext)
        } catch {
            print("Seeding failed: \(error)")
        }
        return container
    }()

    var body: some Scene {
        WindowGroup {
            TripListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
