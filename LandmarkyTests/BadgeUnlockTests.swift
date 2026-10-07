//
//  BadgeUnlockTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

@MainActor
struct BadgeUnlockTests {
    @Test func firstRunRecordsAlreadyEarnedBadgesWithoutCelebrating() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        for index in 1...5 {
            context.insert(TestSupport.visitedLandmark("Place \(index)"))
        }
        try context.save()

        let pending = try BadgeUnlockService(context: context, defaults: defaults).refresh()

        #expect(pending.isEmpty)
        let records = try context.fetch(FetchDescriptor<EarnedBadge>())
        #expect(Set(records.compactMap(\.badge)) == [.firstSteps, .explorer])
        #expect(records.allSatisfy { $0.isCelebrated })
        #expect(defaults.bool(forKey: BadgeUnlockService.baselineKey))
        #expect(try BadgeUnlockService(context: context, defaults: defaults).unlockDates().isEmpty)
    }

    @Test func newUnlockIsRecordedOnceAndQueuedForCelebration() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        let unlockDate = Date(timeIntervalSince1970: 1_790_000_000)
        let service = BadgeUnlockService(context: context, defaults: defaults, now: { unlockDate })
        try service.refresh()

        context.insert(TestSupport.visitedLandmark("Devín Castle"))
        try context.save()

        #expect(try service.refresh() == [.firstSteps])
        #expect(try service.refresh() == [.firstSteps])

        let records = try context.fetch(FetchDescriptor<EarnedBadge>())
        #expect(records.count == 1)
        #expect(records.first?.unlockedAt == unlockDate)
        #expect(records.first?.isCelebrated == false)
    }

    @Test func celebratedBadgesAreNotShownAgain() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        let service = BadgeUnlockService(context: context, defaults: defaults)
        try service.refresh()

        context.insert(TestSupport.visitedLandmark("Devín Castle", image: Data([1])))
        try context.save()
        #expect(try service.refresh() == [.firstSteps, .photographer])

        try service.markCelebrated(.firstSteps)

        #expect(try service.refresh() == [.photographer])
    }

    @Test func unlockSurvivesRelaunchBeforeItWasCelebrated() throws {
        let container = try TestSupport.makeContainer()
        let defaults = TestSupport.makeDefaults()
        let firstLaunch = ModelContext(container)
        try BadgeUnlockService(context: firstLaunch, defaults: defaults).refresh()
        firstLaunch.insert(TestSupport.visitedLandmark("Devín Castle"))
        try firstLaunch.save()
        try BadgeUnlockService(context: firstLaunch, defaults: defaults).refresh()

        let secondLaunch = ModelContext(container)
        let pending = try BadgeUnlockService(context: secondLaunch, defaults: defaults).refresh()

        #expect(pending == [.firstSteps])
    }

    @Test func badgeLostAndRegainedIsNotCelebratedTwice() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        let service = BadgeUnlockService(context: context, defaults: defaults)
        try service.refresh()

        let landmark = TestSupport.visitedLandmark("Devín Castle")
        context.insert(landmark)
        try context.save()
        try service.refresh()
        try service.markCelebrated(.firstSteps)

        context.delete(landmark)
        try context.save()
        context.insert(TestSupport.visitedLandmark("Bratislava Castle"))
        try context.save()

        #expect(try service.refresh().isEmpty)
    }

    @Test func duplicateRecordsFromSyncMergeIntoEarliestUnlock() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        defaults.set(true, forKey: BadgeUnlockService.baselineKey)
        let early = Date(timeIntervalSince1970: 1_700_000_000)
        let late = Date(timeIntervalSince1970: 1_800_000_000)
        context.insert(TestSupport.visitedLandmark("Devín Castle"))
        context.insert(EarnedBadge(badgeID: Badge.firstSteps.id, unlockedAt: late, isCelebrated: true))
        context.insert(EarnedBadge(badgeID: Badge.firstSteps.id, unlockedAt: early, isCelebrated: false))
        try context.save()

        let service = BadgeUnlockService(context: context, defaults: defaults)
        let pending = try service.refresh()

        let records = try context.fetch(FetchDescriptor<EarnedBadge>())
        #expect(records.count == 1)
        #expect(records.first?.unlockedAt == early)
        #expect(records.first?.isCelebrated == true)
        #expect(pending.isEmpty)
        #expect(try service.unlockDates() == [.firstSteps: early])
    }

    @Test func unknownBadgeRecordsFromNewerVersionsAreKeptButIgnored() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        defaults.set(true, forKey: BadgeUnlockService.baselineKey)
        context.insert(EarnedBadge(badgeID: "badgeFromTheFuture"))
        try context.save()

        let pending = try BadgeUnlockService(context: context, defaults: defaults).refresh()

        #expect(pending.isEmpty)
        #expect(try context.fetchCount(FetchDescriptor<EarnedBadge>()) == 1)
    }

    @Test func wishlistedPlacesDoNotUnlockBadges() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        let service = BadgeUnlockService(context: context, defaults: defaults)
        try service.refresh()

        context.insert(Landmark(name: "Someday", category: "Parks", latitude: 48, longitude: 17, isWishlisted: true))
        try context.save()

        #expect(try service.refresh().isEmpty)
    }

    @Test func celebrationQueueShowsBadgesOneAtATime() throws {
        let context = try TestSupport.makeContext()
        let defaults = TestSupport.makeDefaults()
        let viewModel = BadgeCelebrationViewModel()
        viewModel.configure(context: context, defaults: defaults)
        viewModel.refresh()
        #expect(viewModel.current == nil)

        context.insert(TestSupport.visitedLandmark("Devín Castle", image: Data([1])))
        try context.save()
        viewModel.refresh()

        #expect(viewModel.current == .firstSteps)
        #expect(viewModel.position.index == 1)
        #expect(viewModel.position.total == 2)

        viewModel.dismissCurrent()
        #expect(viewModel.current == .photographer)
        #expect(viewModel.position.index == 2)
        #expect(viewModel.position.total == 2)

        viewModel.dismissCurrent()
        #expect(viewModel.current == nil)

        viewModel.refresh()
        #expect(viewModel.current == nil)
    }

    @Test func nextUpSuggestsTheClosestUnearnedBadge() {
        let landmarks = (1...4).map { TestSupport.visitedLandmark("Place \($0)") }
        let stats = BadgeStats(landmarks: landmarks, tripCount: 0)

        let next = Badge.nextUp(stats: stats)

        #expect(next?.badge == .explorer)
        #expect(next?.progress.current == 4)
        #expect(next?.progress.target == 5)
    }

    @Test func nextUpIsNilWithoutAnyProgress() {
        #expect(Badge.nextUp(stats: BadgeStats(landmarks: [], tripCount: 0)) == nil)
    }
}
