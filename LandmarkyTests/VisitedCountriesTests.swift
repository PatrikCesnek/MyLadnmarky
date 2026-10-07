//
//  VisitedCountriesTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

@MainActor
struct VisitedCountriesTests {
    // MARK: - Country catalog

    @Test(arguments: [
        ("Slovakia", "SK"), ("Slovensko", "SK"), ("Czechia", "CZ"), ("Česko", "CZ"),
        ("Czech Republic", "CZ"), ("Rakúsko", "AT"), ("Rakousko", "AT"), ("  austria ", "AT"),
        ("Spojené štáty", "US"), ("United States", "US"), ("Maďarsko", "HU")
    ])
    func countryNamesInAppLanguagesResolveToCodes(name: String, code: String) {
        #expect(CountryCatalog.code(forCountryName: name) == code)
    }

    @Test func unknownCountryNameHasNoCode() {
        #expect(CountryCatalog.code(forCountryName: "Atlantis") == nil)
    }

    @Test func flagEmojiIsBuiltFromCode() {
        #expect(CountryCatalog.flag(for: "SK") == "🇸🇰")
        #expect(CountryCatalog.flag(for: "cz") == "🇨🇿")
        #expect(CountryCatalog.flag(for: "123") == "🏳️")
    }

    // MARK: - Backfill

    @Test func backfillFromNamesFillsCodesWithoutTouchingOtherFields() throws {
        let context = try TestSupport.makeContext()
        let slovak = TestSupport.visitedLandmark("Devín", country: "Slovensko")
        let czech = TestSupport.visitedLandmark("Karlštejn", country: "Czechia", continent: "Europe")
        let unknown = TestSupport.visitedLandmark("Atlantis", country: "Atlantis")
        [slovak, czech, unknown].forEach(context.insert)
        try context.save()

        let updated = try CountryBackfillService(context: context, geocode: { _, _ in nil }).backfillFromNames()

        #expect(updated == 2)
        #expect(slovak.countryCode == "SK")
        #expect(slovak.continent == "Europe")
        #expect(slovak.country == "Slovensko")
        #expect(czech.countryCode == "CZ")
        #expect(unknown.countryCode == nil)
    }

    @Test func backfillByGeocodingFillsMissingCountryData() async throws {
        let context = try TestSupport.makeContext()
        let savedOffline = TestSupport.visitedLandmark("Saved offline")
        let alreadyNamed = TestSupport.visitedLandmark("Named", country: "Slovensko")
        let alreadyCoded = TestSupport.visitedLandmark("Coded", country: "Austria")
        alreadyCoded.countryCode = "AT"
        [savedOffline, alreadyNamed, alreadyCoded].forEach(context.insert)
        try context.save()

        let service = CountryBackfillService(context: context) { _, _ in
            GeocodedPlace(name: nil, country: "Slovakia", countryCode: "SK", continent: "Europe")
        }
        let updated = try await service.backfillByGeocoding()

        #expect(updated == 2)
        #expect(savedOffline.countryCode == "SK")
        #expect(savedOffline.country == "Slovakia")
        #expect(savedOffline.continent == "Europe")
        #expect(alreadyNamed.country == "Slovensko")
        #expect(alreadyCoded.countryCode == "AT")
    }

    @Test func backfillByGeocodingRespectsBatchLimitAndFailures() async throws {
        let context = try TestSupport.makeContext()
        for index in 1...5 {
            context.insert(TestSupport.visitedLandmark("Place \(index)"))
        }
        try context.save()

        let failing = CountryBackfillService(context: context) { _, _ in nil }
        #expect(try await failing.backfillByGeocoding(limit: 3) == 0)

        let working = CountryBackfillService(context: context) { _, _ in
            GeocodedPlace(name: nil, country: "Slovakia", countryCode: "SK", continent: "Europe")
        }
        #expect(try await working.backfillByGeocoding(limit: 3) == 3)
        #expect(try await working.backfillByGeocoding(limit: 3) == 2)
    }

    // MARK: - Summary & badges

    @Test func summaryCountsCountriesContinentsAndShare() {
        let early = Date(timeIntervalSince1970: 1_600_000_000)
        let late = Date(timeIntervalSince1970: 1_700_000_000)
        let landmarks = [
            coded("Bratislava", "SK", visitDate: late),
            coded("Devín", "SK", visitDate: early),
            coded("Prague", "CZ"),
            coded("Tokyo", "JP"),
            Landmark(name: "Someday", category: "Parks", isWishlisted: true, countryCode: "BR"),
            TestSupport.visitedLandmark("No code", country: "Slovakia")
        ]

        let summary = VisitedCountriesSummary(landmarks: landmarks)

        #expect(summary.codes == ["SK", "CZ", "JP"])
        #expect(summary.countries.first { $0.code == "SK" }?.placeCount == 2)
        #expect(summary.countries.first { $0.code == "SK" }?.firstVisit == early)
        #expect(summary.visitedContinentCount == 2)
        #expect(summary.continents.first { $0.continent == "Europe" }?.visited == 2)
        #expect(summary.continents.first { $0.continent == "South America" }?.visited == 0)
        #expect(abs(summary.worldShare - 3.0 / 195.0) < 0.0001)
    }

    @Test func badgesCountACountryOnceAcrossLanguages() {
        let english = coded("Bratislava", "SK")
        english.country = "Slovakia"
        let slovak = coded("Devín", "SK")
        slovak.country = "Slovensko"

        let stats = BadgeStats(landmarks: [english, slovak], tripCount: 0)

        #expect(stats.uniqueCountries == ["SK"])
    }

    // MARK: - World map

    @Test func bundledWorldMapLoadsAndIsNormalized() throws {
        let map = try #require(WorldMap.bundled)
        let codes = Set(map.countries.map(\.code))

        #expect(codes.count > 200)
        #expect(codes.isSuperset(of: ["SK", "CZ", "US", "JP", "BR", "AU", "ZA", "FR", "NO", "XK"]))
        #expect(!codes.contains("AQ"))
        #expect(map.aspectRatio > 0.4 && map.aspectRatio < 0.6)

        let points = map.countries.flatMap(\.rings).flatMap { $0 }
        #expect(points.allSatisfy { (0...1).contains($0.x) && (0...map.aspectRatio).contains($0.y) })
    }

    @Test func everyCountryTheAppCanMapToAContinentHasAShape() throws {
        let map = try #require(WorldMap.bundled)
        let mapped = Set(map.countries.map(\.code))
        let missing = Locale.Region.isoRegions
            .map(\.identifier)
            .filter { $0.count == 2 && ContinentMapper.continent(forCountryCode: $0) != "Unknown" }
            .filter { !mapped.contains($0) }

        #expect(missing.isEmpty, "No map shape for: \(missing)")
    }

    @Test func equalEarthKeepsOriginAndSymmetry() {
        let origin = WorldMap.equalEarth(longitude: 0, latitude: 0)
        let east = WorldMap.equalEarth(longitude: 90, latitude: 45)
        let west = WorldMap.equalEarth(longitude: -90, latitude: -45)

        #expect(origin.x == 0 && origin.y == 0)
        #expect(abs(east.x + west.x) < 1e-9)
        #expect(abs(east.y + west.y) < 1e-9)
    }

    private func coded(_ name: String, _ code: String, visitDate: Date? = nil) -> Landmark {
        Landmark(
            name: name,
            category: "Parks",
            visitDate: visitDate,
            continent: ContinentMapper.continent(forCountryCode: code),
            countryCode: code
        )
    }
}
