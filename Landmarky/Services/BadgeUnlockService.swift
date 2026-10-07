//
//  BadgeUnlockService.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// Records badge unlocks locally the moment they're earned and tracks which ones the user
/// has already seen celebrated. Works fully offline; the records are plain SwiftData rows,
/// so they'll travel with a future iCloud sync.
@MainActor
struct BadgeUnlockService {
    static let baselineKey = "badgeUnlock.baselineEstablished"

    private let context: ModelContext
    private let defaults: UserDefaults
    private let now: () -> Date

    init(context: ModelContext, defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
        self.context = context
        self.defaults = defaults
        self.now = now
    }

    /// Records badges earned since the last call and returns every badge still waiting to be
    /// celebrated, in display order.
    ///
    /// The first run on a device records already-earned badges as celebrated, so people
    /// updating from a version without this feature don't get a burst of old unlocks.
    @discardableResult
    func refresh() throws -> [Badge] {
        let stats = try BadgeStatsProvider.stats(in: context)
        let isBaseline = !defaults.bool(forKey: Self.baselineKey)

        var records = try mergedRecords()
        let recordedIDs = Set(records.map(\.badgeID))

        for badge in Badge.allCases where badge.isEarned(stats: stats) && !recordedIDs.contains(badge.id) {
            let record = EarnedBadge(badgeID: badge.id, unlockedAt: now(), isCelebrated: isBaseline)
            context.insert(record)
            records.append(record)
        }

        if context.hasChanges {
            try context.save()
        }
        if isBaseline {
            defaults.set(true, forKey: Self.baselineKey)
        }

        return Self.pendingCelebrations(in: records)
    }

    func markCelebrated(_ badge: Badge) throws {
        let id = badge.id
        let descriptor = FetchDescriptor<EarnedBadge>(predicate: #Predicate { $0.badgeID == id })
        let records = try context.fetch(descriptor)
        guard records.contains(where: { !$0.isCelebrated }) else { return }

        records.forEach { $0.isCelebrated = true }
        try context.save()
    }

    /// Unlock dates by badge, for timelines such as the year in review.
    func unlockDates() throws -> [Badge: Date] {
        try mergedRecords().reduce(into: [:]) { result, record in
            guard let badge = record.badge else { return }
            result[badge] = record.unlockedAt
        }
    }

    /// One record per badge. Duplicates (e.g. the same unlock arriving from two devices)
    /// collapse into the earliest unlock; it counts as celebrated if any copy was.
    private func mergedRecords() throws -> [EarnedBadge] {
        let all = try context.fetch(FetchDescriptor<EarnedBadge>(sortBy: [SortDescriptor(\.unlockedAt)]))
        var keptByID: [String: EarnedBadge] = [:]
        var kept: [EarnedBadge] = []

        for record in all {
            if let existing = keptByID[record.badgeID] {
                existing.isCelebrated = existing.isCelebrated || record.isCelebrated
                context.delete(record)
            } else {
                keptByID[record.badgeID] = record
                kept.append(record)
            }
        }

        return kept
    }

    static func pendingCelebrations(in records: [EarnedBadge]) -> [Badge] {
        let pending = Set(records.filter { !$0.isCelebrated }.compactMap(\.badge))
        return Badge.allCases.filter { pending.contains($0) }
    }
}
