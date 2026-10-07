//
//  VisitedCountriesSummary.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation

struct VisitedCountry: Identifiable, Equatable, Sendable {
    let code: String
    let placeCount: Int
    let firstVisit: Date?

    var id: String { code }
}

struct ContinentProgress: Identifiable, Equatable, Sendable {
    let continent: String
    let visited: Int
    let total: Int

    var id: String { continent }
}

/// Everything the "Your world" screen and share card show, derived from visited places.
struct VisitedCountriesSummary: Equatable, Sendable {
    let countries: [VisitedCountry]
    let continents: [ContinentProgress]

    var codes: Set<String> { Set(countries.map(\.code)) }

    var visitedContinentCount: Int {
        continents.filter { $0.visited > 0 }.count
    }

    var worldShare: Double {
        min(Double(countries.count) / Double(CountryCatalog.worldCountryCount), 1)
    }

    /// Only visited places with a country code count; wishlisted places don't.
    init(landmarks: [Landmark]) {
        var placeCounts: [String: Int] = [:]
        var firstVisits: [String: Date] = [:]

        for landmark in landmarks where !landmark.isWishlisted {
            guard let code = landmark.countryCode?.uppercased() else { continue }
            placeCounts[code, default: 0] += 1
            if let visitDate = landmark.visitDate {
                firstVisits[code] = min(firstVisits[code] ?? visitDate, visitDate)
            }
        }

        countries = placeCounts
            .map { VisitedCountry(code: $0.key, placeCount: $0.value, firstVisit: firstVisits[$0.key]) }
            .sorted { lhs, rhs in
                CountryCatalog.localizedName(for: lhs.code)
                    .localizedStandardCompare(CountryCatalog.localizedName(for: rhs.code)) == .orderedAscending
            }

        let visitedByContinent = Dictionary(grouping: placeCounts.keys) { ContinentMapper.continent(forCountryCode: $0) }
        continents = ContinentMapper.inhabitedContinents.map { continent in
            ContinentProgress(
                continent: continent,
                visited: visitedByContinent[continent]?.count ?? 0,
                total: ContinentMapper.countryCount(in: continent)
            )
        }
    }
}
