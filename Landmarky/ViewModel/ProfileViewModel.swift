//
//  ProfileViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI
import SwiftData

@Observable
class ProfileViewModel {
    var user: Profile?
    var firstName: String = ""
    var lastName: String?
    var alertText: String?
    var isEditing: Bool = false
    var landmarkCount: Int = 0
    var landmarkCountText: String? {
        "\(Constants.Strings.landmarkCountString1) \(landmarkCount) " + Constants.Strings.landmarkCountString2
    }

    @MainActor
    func loadProfile(using context: ModelContext) {
        let descriptor = FetchDescriptor<Profile>()
        if let existing = try? context.fetch(descriptor).first {
            user = existing
            firstName = existing.name
            lastName = existing.lastName
        } else {
            isEditing = true
        }

        let landmarkDescriptor = FetchDescriptor<Landmark>()
        landmarkCount = (try? context.fetchCount(landmarkDescriptor)) ?? 0
    }

    @MainActor
    func editProfile(using context: ModelContext) {
        if isEditing {
            saveProfile(using: context)
        }

        isEditing.toggle()
    }

    @MainActor
    private func saveProfile(using context: ModelContext) {
        guard !firstName.isEmpty else {
            alertText = Constants.Strings.enterName
            return
        }

        if let user {
            user.name = firstName
            user.lastName = lastName
        } else {
            let newProfile = Profile(name: firstName, lastName: lastName)
            context.insert(newProfile)
            user = newProfile
        }

        do {
            try context.save()
        } catch {
            alertText = error.localizedDescription
        }
    }
}
