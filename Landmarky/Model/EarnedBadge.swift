//
//  EarnedBadge.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// A badge unlock recorded on device the moment it happens, independent of any network.
///
/// Every attribute has a default and there is no uniqueness constraint so the record can
/// later sync through a CloudKit private database; duplicates that sync could produce are
/// merged by `BadgeUnlockService`.
@Model
final class EarnedBadge {
    var badgeID: String = ""
    var unlockedAt: Date = Date()
    var isCelebrated: Bool = false

    init(badgeID: String, unlockedAt: Date = Date(), isCelebrated: Bool = false) {
        self.badgeID = badgeID
        self.unlockedAt = unlockedAt
        self.isCelebrated = isCelebrated
    }

    var badge: Badge? {
        Badge(rawValue: badgeID)
    }
}
