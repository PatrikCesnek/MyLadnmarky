//
//  TestSupport.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
@testable import Landmarky

enum TestSupport {
    @MainActor
    static func makeContainer() throws -> ModelContainer {
        let schema = AppSchema.schema
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    @MainActor
    static func makeContext() throws -> ModelContext {
        ModelContext(try makeContainer())
    }

    /// Isolated defaults so tests never touch (or depend on) the simulator's real ones.
    static func makeDefaults() -> UserDefaults {
        let suiteName = "LandmarkyTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    static func visitedLandmark(
        _ name: String,
        category: String = Constants.Categories.parks,
        country: String? = nil,
        continent: String? = nil,
        image: Data? = nil,
        visitDate: Date? = nil
    ) -> Landmark {
        Landmark(
            name: name,
            category: category,
            latitude: 48.1,
            longitude: 17.1,
            image: image,
            visitDate: visitDate,
            country: country,
            continent: continent
        )
    }
}
