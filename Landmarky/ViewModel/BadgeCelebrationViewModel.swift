//
//  BadgeCelebrationViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftData
import SwiftUI

/// App-wide queue of badge unlocks waiting to be shown, one at a time.
@MainActor
@Observable
final class BadgeCelebrationViewModel {
    private(set) var queue: [Badge] = []
    private(set) var shownCount = 0
    private var service: BadgeUnlockService?

    var current: Badge? { queue.first }

    /// Position of the current badge within this batch of unlocks, e.g. (2, 3).
    var position: (index: Int, total: Int) {
        (shownCount + 1, shownCount + queue.count)
    }

    func configure(context: ModelContext, defaults: UserDefaults = .standard) {
        guard service == nil else { return }
        service = BadgeUnlockService(context: context, defaults: defaults)
    }

    func refresh() {
        guard let service, let pending = try? service.refresh() else { return }
        let newlyQueued = pending.filter { !queue.contains($0) }
        if queue.isEmpty {
            shownCount = 0
        }
        queue.append(contentsOf: newlyQueued)
    }

    func dismissCurrent() {
        guard let badge = queue.first else { return }
        try? service?.markCelebrated(badge)
        queue.removeFirst()
        shownCount += 1
    }
}
