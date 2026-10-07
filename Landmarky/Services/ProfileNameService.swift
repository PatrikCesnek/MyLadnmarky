//
//  ProfileNameService.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftData

/// Saves the user's name to the single `Profile`, creating it on first use.
@MainActor
enum ProfileNameService {
    /// Trims input; an empty first name saves nothing. Returns whether a name was stored.
    @discardableResult
    static func save(firstName: String, lastName: String, in context: ModelContext) throws -> Bool {
        let first = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !first.isEmpty else { return false }

        if let profile = try context.fetch(FetchDescriptor<Profile>()).first {
            profile.name = first
            profile.lastName = last.isEmpty ? nil : last
        } else {
            context.insert(Profile(name: first, lastName: last.isEmpty ? nil : last))
        }
        try context.save()
        return true
    }
}
