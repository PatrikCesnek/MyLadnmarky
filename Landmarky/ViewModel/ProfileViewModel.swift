//
//  ProfileViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import PhotosUI
import SwiftUI
import SwiftData

@Observable
class ProfileViewModel {
    var user: Profile?
    var firstName: String = ""
    var lastName: String?
    var selectedImageData: Data?
    var showPhotoSourceSheet = false
    var showCamera = false
    var showPhotoPicker = false
    var alertText: String?
    var isEditing: Bool = false
    var landmarkCount: Int = 0
    var badgeStats: BadgeStats?
    var badgeItems: [BadgeItem] = []
    var landmarkCountText: String? {
        "\(Constants.Strings.landmarkCountString1) \(landmarkCount) " + Constants.Strings.landmarkCountString2
    }

    @MainActor
    func loadProfile(using context: ModelContext) {
        if Constants.showsMockData {
            let mockUser = Mock.MockProfile.user
            user = mockUser
            firstName = mockUser.name
            lastName = mockUser.lastName
            selectedImageData = mockUser.image
            isEditing = false

            let landmarks = Mock.MockLandmarks.data.filter { !$0.isWishlisted }
            landmarkCount = landmarks.count

            let stats = BadgeStats(landmarks: landmarks, tripCount: Mock.MockTrips.data.count)
            badgeStats = stats
            badgeItems = Badge.evaluateAll(stats: stats)
            return
        }

        let descriptor = FetchDescriptor<Profile>()
        if let existing = try? context.fetch(descriptor).first {
            user = existing
            firstName = existing.name
            lastName = existing.lastName
            selectedImageData = existing.image
        } else {
            isEditing = true
        }

        let landmarkDescriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.isWishlisted == false }
        )
        let landmarks = (try? context.fetch(landmarkDescriptor)) ?? []
        landmarkCount = landmarks.count

        let tripDescriptor = FetchDescriptor<Trip>()
        let tripCount = (try? context.fetchCount(tripDescriptor)) ?? 0

        let stats = BadgeStats(landmarks: landmarks, tripCount: tripCount)
        badgeStats = stats
        badgeItems = Badge.evaluateAll(stats: stats)
    }

    func handlePickedImage(_ image: UIImage?) {
        guard let image else { return }
        selectedImageData = image.jpegData(compressionQuality: 0.8)
    }

    @MainActor
    func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            handlePickedImage(image)
        }
    }

    @MainActor
    func editProfile(using context: ModelContext) {
        if Constants.showsMockData {
            if isEditing && !saveMockProfile() {
                return
            }

            isEditing.toggle()
            return
        }

        if isEditing && !saveProfile(using: context) {
            return
        }

        isEditing.toggle()
    }

    @discardableResult
    private func saveMockProfile() -> Bool {
        firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        lastName = lastName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if lastName?.isEmpty == true {
            lastName = nil
        }

        guard !firstName.isEmpty else {
            alertText = Constants.Strings.enterName
            return false
        }

        user = Profile(name: firstName, lastName: lastName, image: selectedImageData)
        alertText = nil
        return true
    }

    @MainActor
    @discardableResult
    private func saveProfile(using context: ModelContext) -> Bool {
        firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        lastName = lastName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if lastName?.isEmpty == true {
            lastName = nil
        }

        guard !firstName.isEmpty else {
            alertText = Constants.Strings.enterName
            return false
        }

        if let user {
            user.name = firstName
            user.lastName = lastName
            user.image = selectedImageData
        } else {
            let newProfile = Profile(name: firstName, lastName: lastName, image: selectedImageData)
            context.insert(newProfile)
            user = newProfile
        }

        do {
            try context.save()
            alertText = nil
            return true
        } catch {
            alertText = error.localizedDescription
            return false
        }
    }
}
