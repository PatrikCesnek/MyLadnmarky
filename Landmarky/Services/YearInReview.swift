//
//  YearInReview.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation

/// One year of exploring, summarized. Pure: built from plain values so it's fully testable.
struct YearInReview: Equatable, Sendable {
    struct CategoryCount: Equatable, Sendable {
        let category: String
        let count: Int
    }

    struct TripLength: Equatable, Sendable {
        let title: String
        let days: Int
    }

    struct MonthCount: Equatable, Sendable {
        /// 1...12
        let month: Int
        let count: Int
    }

    let year: Int
    let placeCount: Int
    let photoCount: Int
    /// Countries visited this year, in order of first visit.
    let countryCodes: [String]
    /// Countries visited for the very first time this year.
    let newCountryCodes: [String]
    let continentCount: Int
    let topCategory: CategoryCount?
    let tripCount: Int
    let longestTrip: TripLength?
    let busiestMonth: MonthCount?
    let badges: [Badge]

    var isEmpty: Bool {
        placeCount == 0 && tripCount == 0 && badges.isEmpty
    }

    init(
        year: Int,
        landmarks: [Landmark],
        trips: [Trip],
        badgeUnlocks: [Badge: Date],
        calendar: Calendar = .current
    ) {
        self.year = year
        let visited = landmarks
            .filter { !$0.isWishlisted }
            .compactMap { landmark in landmark.visitDate.map { (landmark: landmark, date: $0) } }
            .sorted { $0.date < $1.date }
        let thisYear = visited.filter { calendar.component(.year, from: $0.date) == year }

        placeCount = thisYear.count
        photoCount = thisYear.filter { $0.landmark.image != nil }.count

        var seen = Set<String>()
        countryCodes = thisYear.compactMap(\.landmark.countryCode).filter { seen.insert($0).inserted }

        let earlierCountries = Set(
            visited
                .filter { calendar.component(.year, from: $0.date) < year }
                .compactMap(\.landmark.countryCode)
        )
        newCountryCodes = countryCodes.filter { !earlierCountries.contains($0) }

        continentCount = Set(
            countryCodes
                .map { ContinentMapper.continent(forCountryCode: $0) }
                .filter { $0 != "Unknown" }
        ).count

        let categoryCounts = Dictionary(grouping: thisYear, by: \.landmark.category).mapValues(\.count)
        topCategory = categoryCounts
            .max { lhs, rhs in lhs.value == rhs.value ? lhs.key > rhs.key : lhs.value < rhs.value }
            .map { CategoryCount(category: $0.key, count: $0.value) }

        let monthCounts = Dictionary(grouping: thisYear) { calendar.component(.month, from: $0.date) }.mapValues(\.count)
        busiestMonth = monthCounts
            .max { lhs, rhs in lhs.value == rhs.value ? lhs.key > rhs.key : lhs.value < rhs.value }
            .map { MonthCount(month: $0.key, count: $0.value) }

        let tripsThisYear = trips.filter { calendar.component(.year, from: $0.startDate) == year }
        tripCount = tripsThisYear.count
        longestTrip = tripsThisYear
            .map { trip in
                let start = calendar.startOfDay(for: trip.startDate)
                let end = calendar.startOfDay(for: max(trip.endDate ?? trip.startDate, trip.startDate))
                let days = (calendar.dateComponents([.day], from: start, to: end).day ?? 0) + 1
                return TripLength(title: trip.title, days: days)
            }
            .max { lhs, rhs in lhs.days == rhs.days ? lhs.title > rhs.title : lhs.days < rhs.days }

        badges = Badge.allCases.filter { badge in
            badgeUnlocks[badge].map { calendar.component(.year, from: $0) == year } ?? false
        }
    }

    /// Years with anything to look back on, newest first.
    static func availableYears(
        landmarks: [Landmark],
        trips: [Trip],
        badgeUnlocks: [Badge: Date],
        calendar: Calendar = .current
    ) -> [Int] {
        let landmarkYears = landmarks
            .filter { !$0.isWishlisted }
            .compactMap(\.visitDate)
            .map { calendar.component(.year, from: $0) }
        let tripYears = trips.map { calendar.component(.year, from: $0.startDate) }
        let badgeYears = badgeUnlocks.values.map { calendar.component(.year, from: $0) }
        return Set(landmarkYears + tripYears + badgeYears).sorted(by: >)
    }

    /// The year to feature on Home: the closing year during December and January.
    static func featuredYear(today: Date, calendar: Calendar = .current) -> Int? {
        let year = calendar.component(.year, from: today)
        switch calendar.component(.month, from: today) {
        case 12: return year
        case 1: return year - 1
        default: return nil
        }
    }
}
