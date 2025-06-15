//
//  ProfileViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI
import SwiftData
import Combine

@Observable
class ProfileViewModel {
    var user: Profile?
    var firstName: String = Constants.Strings.enterName
    var lastName: String?
    var alertText: String?
    var isEditing: Bool = false
    var landmarkCount: Int?
    var landmarkCountText: String? {
        landmarkCount.map { "\(Constants.Strings.landmarkCountString1) \($0) " + Constants.Strings.landmarkCountString2 }
    }
    
    init() {
        createMockUser()
    }
    func createMockUser() {
        user = Profile(id: UUID(), name: "John", lastName: "Doe", landmarkCount: Mock.MockLandmarks.data.count)
        landmarkCount = user?.landmarkCount
    }
    
    @MainActor
    func editProfile(using context: ModelContext) {
        if isEditing {
            createNewUser(using: context)
        }
        
        isEditing.toggle()
    }
    
    @MainActor
    func createNewUser(using context: ModelContext) {
        let landmarkCount = user?.landmarkCount ?? 0
        user = Profile(id: UUID(), name: firstName, lastName: lastName, landmarkCount: landmarkCount)
        
        checkIfEmpty()
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func checkIfEmpty() {
        guard !firstName.isEmpty else {
            return
        }
    }
}
