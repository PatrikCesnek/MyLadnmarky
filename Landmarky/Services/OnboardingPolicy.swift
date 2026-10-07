//
//  OnboardingPolicy.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// Decides whether to show onboarding. New installs see it once; people updating with
/// existing data are treated as already onboarded.
@MainActor
struct OnboardingPolicy {
    static let completedKey = "onboarding.completed"

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isCompleted: Bool {
        defaults.bool(forKey: Self.completedKey)
    }

    func shouldShow(in context: ModelContext) -> Bool {
        guard !isCompleted else { return false }

        if hasExistingData(in: context) {
            markCompleted()
            return false
        }
        return true
    }

    func markCompleted() {
        defaults.set(true, forKey: Self.completedKey)
    }

    private func hasExistingData(in context: ModelContext) -> Bool {
        let landmarks = (try? context.fetchCount(FetchDescriptor<Landmark>())) ?? 0
        let trips = (try? context.fetchCount(FetchDescriptor<Trip>())) ?? 0
        let profiles = (try? context.fetchCount(FetchDescriptor<Profile>())) ?? 0
        return landmarks + trips + profiles > 0
    }
}
