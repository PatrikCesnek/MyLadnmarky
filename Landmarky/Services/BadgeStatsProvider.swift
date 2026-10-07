//
//  BadgeStatsProvider.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// Builds `BadgeStats` from the store. Wishlisted places don't count until visited.
@MainActor
enum BadgeStatsProvider {
    static func stats(in context: ModelContext) throws -> BadgeStats {
        let visited = FetchDescriptor<Landmark>(predicate: #Predicate { $0.isWishlisted == false })
        let landmarks = try context.fetch(visited)
        let tripCount = try context.fetchCount(FetchDescriptor<Trip>())
        return BadgeStats(landmarks: landmarks, tripCount: tripCount)
    }
}
