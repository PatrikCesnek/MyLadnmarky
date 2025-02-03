//
//  Profile.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

import Foundation
import SwiftData

@Model
final class Profile {
    var id = UUID()
    var name: String
    var lastName: String?
    var landmarkCount: Int = 0
    
    init(id: UUID = UUID(), name: String, lastName: String? = nil, landmarkCount: Int = 0) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.landmarkCount = landmarkCount
    }
}
