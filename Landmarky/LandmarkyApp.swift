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
    private var sharedModelContainer: ModelContainer?

    init() {
        self.sharedModelContainer = try? ModelContainer(for: AppSchema.schema)
    }

    var body: some Scene {
        WindowGroup {
            if let container = sharedModelContainer {
                ContentView()
                    .tint(.green)
                    .modelContainer(container)
            } else {
                ErrorView(
                    errorString: Constants.Strings.errorTitle
                )
            }
        }
    }
}
