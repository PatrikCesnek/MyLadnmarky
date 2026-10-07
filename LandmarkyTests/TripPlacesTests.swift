//
//  TripPlacesTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

@MainActor
struct TripPlacesTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Bratislava")!
        return calendar
    }()

    private func date(_ day: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 9, day: day, hour: hour))!
    }

    @Test func suggestionsIncludeEveryDayOfTheTripInclusive() {
        let before = TestSupport.visitedLandmark("Before", visitDate: date(9, hour: 23))
        let firstMorning = TestSupport.visitedLandmark("First morning", visitDate: date(10, hour: 0))
        let lastEvening = TestSupport.visitedLandmark("Last evening", visitDate: date(12, hour: 23))
        let after = TestSupport.visitedLandmark("After", visitDate: date(13, hour: 0))
        let undated = TestSupport.visitedLandmark("Undated")
        let wishlisted = Landmark(name: "Wishlisted", category: "Parks", isWishlisted: true, visitDate: date(11))

        let result = TripPlaces.suggestions(
            startDate: date(10, hour: 18),
            endDate: date(12, hour: 6),
            from: [after, lastEvening, undated, before, wishlisted, firstMorning],
            calendar: calendar
        )

        #expect(result.map(\.name) == ["First morning", "Last evening"])
    }

    @Test func singleDayTripSuggestsOnlyThatDay() {
        let sameDay = TestSupport.visitedLandmark("Same day", visitDate: date(10, hour: 8))
        let nextDay = TestSupport.visitedLandmark("Next day", visitDate: date(11, hour: 8))

        let result = TripPlaces.suggestions(startDate: date(10), endDate: nil, from: [sameDay, nextDay], calendar: calendar)

        #expect(result.map(\.name) == ["Same day"])
    }

    @Test func endDateBeforeStartIsTreatedAsSingleDay() {
        let sameDay = TestSupport.visitedLandmark("Same day", visitDate: date(10, hour: 8))

        let result = TripPlaces.suggestions(startDate: date(10), endDate: date(5), from: [sameDay], calendar: calendar)

        #expect(result.map(\.name) == ["Same day"])
    }

    @Test func visitOrderPutsDatedPlacesFirstThenUndatedByName() {
        let landmarks = [
            TestSupport.visitedLandmark("Zebra"),
            TestSupport.visitedLandmark("Late", visitDate: date(12)),
            TestSupport.visitedLandmark("apple"),
            TestSupport.visitedLandmark("Early", visitDate: date(10))
        ]

        #expect(TripPlaces.visitOrder(landmarks).map(\.name) == ["Early", "Late", "apple", "Zebra"])
    }

    @Test func routeSkipsPlacesWithoutCoordinates() {
        let first = TestSupport.visitedLandmark("First", visitDate: date(10))
        let noCoordinates = Landmark(name: "Nowhere", category: "Parks", visitDate: date(11))
        let second = Landmark(name: "Second", category: "Parks", latitude: 50, longitude: 14, visitDate: date(12))

        let route = TripPlaces.route([second, noCoordinates, first])

        #expect(route.count == 2)
        #expect(route.first?.latitude == first.latitude)
        #expect(route.last?.latitude == 50)
    }

    @Test func deletingTripKeepsItsPlaces() throws {
        let context = try TestSupport.makeContext()
        let castle = TestSupport.visitedLandmark("Devín Castle")
        let trip = Trip(title: "Bratislava")
        context.insert(castle)
        context.insert(trip)
        trip.landmarks = [castle]
        try context.save()
        #expect(castle.trips?.map(\.title) == ["Bratislava"])

        context.delete(trip)
        try context.save()

        let landmarks = try context.fetch(FetchDescriptor<Landmark>())
        #expect(landmarks.map(\.name) == ["Devín Castle"])
        #expect(landmarks.first?.trips?.isEmpty ?? true)
    }

    @Test func deletingPlaceKeepsTripAndUnlinksIt() throws {
        let context = try TestSupport.makeContext()
        let castle = TestSupport.visitedLandmark("Devín Castle")
        let lake = TestSupport.visitedLandmark("Lake")
        let trip = Trip(title: "Bratislava")
        context.insert(castle)
        context.insert(lake)
        context.insert(trip)
        trip.landmarks = [castle, lake]
        try context.save()

        try HelperFunctions.deleteLandmark(using: context, landmark: castle)

        let trips = try context.fetch(FetchDescriptor<Trip>())
        #expect(trips.count == 1)
        #expect(trips.first?.landmarks?.map(\.name) == ["Lake"])
    }

    @Test func placeCanBelongToSeveralTrips() throws {
        let context = try TestSupport.makeContext()
        let castle = TestSupport.visitedLandmark("Devín Castle")
        let spring = Trip(title: "Spring", startDate: date(1))
        let autumn = Trip(title: "Autumn", startDate: date(20))
        context.insert(castle)
        context.insert(spring)
        context.insert(autumn)
        spring.landmarks = [castle]
        autumn.landmarks = [castle]
        try context.save()

        #expect(castle.linkedTrips.map(\.title) == ["Autumn", "Spring"])
    }
}
