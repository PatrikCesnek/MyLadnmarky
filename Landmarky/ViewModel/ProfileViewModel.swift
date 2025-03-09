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
    var alertText: String?
    var landmarkCount: Int?
    var landmarkCountText: String? {
        landmarkCount.map { "\(Constants.Strings.landmarkCountString1) \($0) " + Constants.Strings.landmarkCountString2 }
    }
    
    func createMockUser() {
        user = Profile(id: UUID(), name: "John", lastName: "Doe", landmarkCount: 2)
        landmarkCount = user?.landmarkCount
    }
}
