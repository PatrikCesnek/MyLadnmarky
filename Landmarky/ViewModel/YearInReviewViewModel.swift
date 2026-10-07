//
//  YearInReviewViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class YearInReviewViewModel {
    private(set) var availableYears: [Int] = []
    private(set) var review: YearInReview?
    var selectedYear: Int? {
        didSet { rebuild() }
    }

    private var landmarks: [Landmark] = []
    private var trips: [Trip] = []
    private var badgeUnlocks: [Badge: Date] = [:]
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    /// Loads everything once; `preferredYear` wins if it has data, else the newest year.
    func load(using context: ModelContext, preferredYear: Int? = nil, defaults: UserDefaults = .standard) {
        landmarks = (try? context.fetch(FetchDescriptor<Landmark>())) ?? []
        trips = (try? context.fetch(FetchDescriptor<Trip>())) ?? []
        badgeUnlocks = (try? BadgeUnlockService(context: context, defaults: defaults).unlockDates()) ?? [:]

        availableYears = YearInReview.availableYears(
            landmarks: landmarks,
            trips: trips,
            badgeUnlocks: badgeUnlocks,
            calendar: calendar
        )
        if let preferredYear, availableYears.contains(preferredYear) {
            selectedYear = preferredYear
        } else {
            selectedYear = availableYears.first
        }
    }

    private func rebuild() {
        guard let selectedYear else {
            review = nil
            return
        }
        review = YearInReview(
            year: selectedYear,
            landmarks: landmarks,
            trips: trips,
            badgeUnlocks: badgeUnlocks,
            calendar: calendar
        )
    }
}
