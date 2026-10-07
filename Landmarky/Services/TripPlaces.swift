//
//  TripPlaces.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation

/// Rules for linking places to trips.
enum TripPlaces {
    /// Visited places whose visit date falls on any day of the trip, in visit order.
    static func suggestions(
        startDate: Date,
        endDate: Date?,
        from landmarks: [Landmark],
        calendar: Calendar = .current
    ) -> [Landmark] {
        let firstDay = calendar.startOfDay(for: startDate)
        let lastDay = calendar.startOfDay(for: max(endDate ?? startDate, startDate))
        guard let end = calendar.date(byAdding: .day, value: 1, to: lastDay) else { return [] }

        let matching = landmarks.filter { landmark in
            guard !landmark.isWishlisted, let visitDate = landmark.visitDate else { return false }
            return visitDate >= firstDay && visitDate < end
        }
        return visitOrder(matching)
    }

    /// Dated places first (oldest visit first), then undated ones by name.
    static func visitOrder(_ landmarks: [Landmark]) -> [Landmark] {
        landmarks.sorted { lhs, rhs in
            switch (lhs.visitDate, rhs.visitDate) {
            case let (lhsDate?, rhsDate?) where lhsDate != rhsDate:
                return lhsDate < rhsDate
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            default:
                return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
        }
    }

    /// Points to draw a route through, in visit order. Places without coordinates are skipped.
    static func route(_ landmarks: [Landmark]) -> [(latitude: Double, longitude: Double)] {
        visitOrder(landmarks).compactMap { landmark in
            guard let latitude = landmark.latitude, let longitude = landmark.longitude else { return nil }
            return (latitude, longitude)
        }
    }
}
