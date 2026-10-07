//
//  SchemaMigrationTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

/// Opens stores written by the released apps with the current schema.
///
/// `Fixtures/Store-v1.x.store` were produced by running the shipped code (v1.0 = 2287576,
/// v1.1 = 34f63fb) — they are byte-for-byte what users have on their phones. When a
/// release changes the schema, add a fixture generated from that release; never edit these.
@MainActor
@Suite(.serialized)
struct SchemaMigrationTests {
    private let visitDate = Date(timeIntervalSince1970: 1_750_000_000)
    private let photo = Data([0xFF, 0xD8, 0xFF, 0xE0, 0x01, 0x02])

    @Test(arguments: ["Store-v1.0", "Store-v1.1"])
    func releasedStoreOpensWithCurrentSchemaWithoutDataLoss(fixture: String) throws {
        let url = try copyFixture(named: fixture)
        defer { try? FileManager.default.removeItem(at: url.deletingLastPathComponent()) }

        let schema = AppSchema.schema
        let container = try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(schema: schema, url: url)
        )
        let context = ModelContext(container)

        let landmarks = try context.fetch(FetchDescriptor<Landmark>())
        let castle = try #require(landmarks.first { $0.name == "Devín Castle" })
        #expect(castle.category == "Castles")
        #expect(castle.latitude == 48.174)
        #expect(castle.longitude == 16.978)
        #expect(castle.image == photo)
        #expect(castle.landmarkDescription == "Ruins above the Danube")
        #expect(castle.isFavorite)
        #expect(castle.isWishlisted == false)
        #expect(castle.visitDate == visitDate)
        #expect(castle.country == "Slovakia")
        #expect(castle.continent == "Europe")

        if fixture == "Store-v1.1" {
            let wishlisted = try #require(landmarks.first { $0.name == "Sky Bridge" })
            #expect(wishlisted.isWishlisted)
            #expect(wishlisted.visitDate == nil)
        }

        let profile = try #require(try context.fetch(FetchDescriptor<Profile>()).first)
        #expect(profile.name == "Patrik")
        #expect(profile.lastName == "Cesnek")
        #expect(profile.image == photo)

        let trip = try #require(try context.fetch(FetchDescriptor<Trip>()).first)
        #expect(trip.title == "Vienna")
        #expect(trip.notes == "Sachertorte")
        #expect(trip.photoData == [photo, photo])

        try assertNewSchemaDefaults(landmarks: landmarks, trip: trip, context: context)
    }

    /// Defaults every attribute/relationship added after v1.1 must have on migrated rows,
    /// and proof that the migrated store accepts writes of the new models.
    private func assertNewSchemaDefaults(landmarks: [Landmark], trip: Trip, context: ModelContext) throws {
        #expect(try context.fetch(FetchDescriptor<EarnedBadge>()).isEmpty)
        #expect(trip.landmarks?.isEmpty ?? true)
        #expect(landmarks.allSatisfy { $0.trips?.isEmpty ?? true })

        trip.landmarks = landmarks
        try context.save()
        #expect(landmarks.allSatisfy { $0.trips?.count == 1 })

        #expect(landmarks.allSatisfy { $0.countryCode == nil })
        try CountryBackfillService(context: context, geocode: { _, _ in nil }).backfillFromNames()
        #expect(landmarks.first { $0.name == "Devín Castle" }?.countryCode == "SK")

        context.insert(EarnedBadge(badgeID: Badge.firstSteps.id))
        try context.save()
        #expect(try context.fetchCount(FetchDescriptor<EarnedBadge>()) == 1)
    }

    private func copyFixture(named name: String) throws -> URL {
        let source = try #require(
            Bundle(for: FixtureBundleToken.self).url(forResource: name, withExtension: "store"),
            "Missing fixture \(name).store in the test bundle"
        )
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("SchemaMigrationTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let destination = directory.appendingPathComponent("default.store")
        try FileManager.default.copyItem(at: source, to: destination)
        return destination
    }
}

private final class FixtureBundleToken {}
