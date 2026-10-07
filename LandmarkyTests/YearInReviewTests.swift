//
//  YearInReviewTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

@MainActor
struct YearInReviewTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Bratislava")!
        return calendar
    }()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
    }

    private func place(_ name: String, _ code: String?, _ date: Date?, category: String = "Castles", photo: Bool = false) -> Landmark {
        Landmark(
            name: name,
            category: category,
            image: photo ? Data([1]) : nil,
            visitDate: date,
            continent: code.map { ContinentMapper.continent(forCountryCode: $0) },
            countryCode: code
        )
    }

    @Test func summarizesOnlyTheChosenYear() {
        let landmarks = [
            place("Old Prague", "CZ", date(2025, 5, 1)),
            place("Devín", "SK", date(2026, 3, 10), photo: true),
            place("Bratislava", "SK", date(2026, 8, 2)),
            place("Prague again", "CZ", date(2026, 8, 20), category: "Bars"),
            place("Kyoto", "JP", date(2026, 8, 25)),
            place("Next year", "FR", date(2027, 1, 2)),
            place("Undated", "IT", nil),
            Landmark(name: "Someday", category: "Parks", isWishlisted: true, visitDate: date(2026, 4, 4), countryCode: "BR")
        ]

        let review = YearInReview(year: 2026, landmarks: landmarks, trips: [], badgeUnlocks: [:], calendar: calendar)

        #expect(review.placeCount == 4)
        #expect(review.photoCount == 1)
        #expect(review.countryCodes == ["SK", "CZ", "JP"])
        #expect(review.newCountryCodes == ["SK", "JP"])
        #expect(review.continentCount == 2)
        #expect(review.topCategory == .init(category: "Castles", count: 3))
        #expect(review.busiestMonth == .init(month: 8, count: 3))
    }

    @Test func longestTripCountsDaysInclusively() {
        let weekend = Trip(title: "Weekend", startDate: date(2026, 6, 5), endDate: date(2026, 6, 7))
        let dayTrip = Trip(title: "Day trip", startDate: date(2026, 7, 1))
        let lastYear = Trip(title: "Long ago", startDate: date(2025, 1, 1), endDate: date(2025, 1, 30))

        let review = YearInReview(year: 2026, landmarks: [], trips: [weekend, dayTrip, lastYear], badgeUnlocks: [:], calendar: calendar)

        #expect(review.tripCount == 2)
        #expect(review.longestTrip == .init(title: "Weekend", days: 3))
    }

    @Test func includesOnlyBadgesUnlockedThatYear() {
        let unlocks: [Badge: Date] = [
            .firstSteps: date(2025, 12, 31),
            .explorer: date(2026, 1, 1),
            .borderCrosser: date(2026, 9, 9)
        ]

        let review = YearInReview(year: 2026, landmarks: [], trips: [], badgeUnlocks: unlocks, calendar: calendar)

        #expect(review.badges == [.explorer, .borderCrosser])
        #expect(!review.isEmpty)
    }

    @Test func emptyYearIsEmpty() {
        let review = YearInReview(year: 2026, landmarks: [], trips: [], badgeUnlocks: [:], calendar: calendar)

        #expect(review.isEmpty)
        #expect(review.topCategory == nil)
        #expect(review.busiestMonth == nil)
        #expect(review.longestTrip == nil)
    }

    @Test func availableYearsAreNewestFirstAndIgnoreWishlist() {
        let years = YearInReview.availableYears(
            landmarks: [
                place("A", "SK", date(2024, 1, 1)),
                Landmark(name: "Wish", category: "Parks", isWishlisted: true, visitDate: date(2020, 1, 1))
            ],
            trips: [Trip(title: "T", startDate: date(2026, 2, 2))],
            badgeUnlocks: [.firstSteps: date(2025, 3, 3)],
            calendar: calendar
        )

        #expect(years == [2026, 2025, 2024])
    }

    @Test(arguments: [
        (12, 2026, Optional(2026)),
        (1, 2027, Optional(2026)),
        (6, 2026, nil)
    ])
    func featuredYearIsTheClosingYearAroundNewYear(month: Int, year: Int, expected: Int?) {
        #expect(YearInReview.featuredYear(today: date(year, month, 15), calendar: calendar) == expected)
    }

    @Test func viewModelPicksPreferredYearOrNewest() throws {
        let context = try TestSupport.makeContext()
        context.insert(place("A", "SK", date(2024, 5, 5)))
        context.insert(place("B", "CZ", date(2025, 5, 5)))
        try context.save()
        let viewModel = YearInReviewViewModel(calendar: calendar)

        viewModel.load(using: context, defaults: TestSupport.makeDefaults())
        #expect(viewModel.availableYears == [2025, 2024])
        #expect(viewModel.review?.year == 2025)

        viewModel.load(using: context, preferredYear: 2024, defaults: TestSupport.makeDefaults())
        #expect(viewModel.review?.year == 2024)
        #expect(viewModel.review?.countryCodes == ["SK"])

        viewModel.load(using: context, preferredYear: 1999, defaults: TestSupport.makeDefaults())
        #expect(viewModel.review?.year == 2025)
    }

    @Test func badgesFromFirstRunBaselineDoNotAppearInAnyYear() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        context.insert(place("Earned long ago", "SK", date(2024, 5, 5)))
        try context.save()
        try BadgeUnlockService(context: context, defaults: defaults).refresh()

        let viewModel = YearInReviewViewModel(calendar: calendar)
        viewModel.load(using: context, defaults: defaults)

        #expect(viewModel.review?.badges.isEmpty == true)
        #expect(viewModel.availableYears == [2024])
    }
}
