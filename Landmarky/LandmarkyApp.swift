//
//  LandmarkyApp.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

import SwiftUI
import SwiftData

@main
struct LandmarkyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Landmark.self, Profile.self])
        let container = try? ModelContainer(for: schema)
        guard let container = container else {
            fatalError(#function + ": Failed to create ModelContainer")
        }
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .tint(.green)
        }
        .modelContainer(sharedModelContainer)
    }
}
