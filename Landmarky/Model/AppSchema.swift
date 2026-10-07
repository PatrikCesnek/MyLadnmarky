//
//  AppSchema.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftData

/// Single source of truth for the persisted models.
///
/// Rules that keep existing users' stores migrating automatically (and keep the
/// schema ready for a future CloudKit private database):
/// - only add models, optional attributes, or attributes with a default value
/// - relationships are optional and declare an inverse
/// - no `@Attribute(.unique)` constraints
/// `SchemaMigrationTests` opens stores written by every released schema with this one.
enum AppSchema {
    static let models: [any PersistentModel.Type] = [
        Landmark.self,
        Profile.self,
        Trip.self,
        EarnedBadge.self
    ]

    static var schema: Schema {
        Schema(models)
    }
}
