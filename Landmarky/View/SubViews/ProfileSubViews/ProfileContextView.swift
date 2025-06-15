//
//  ProfileContextView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 15/06/2025.
//

import SwiftUI

struct ProfileContextView: View {
    private let name: String
    private let lastName: String?
    private let landmarkCount: String

    init(
        name: String,
        lastName: String?,
        landmarkCount: String
    ) {
        self.name = name
        self.lastName = lastName
        self.landmarkCount = landmarkCount
    }

    var body: some View {
        VStack(alignment: .leading) {
            ProfileCellView(text: name)
            if let lastName = lastName {
                ProfileCellView(text: lastName)
            }
            ProfileCellView(
                text: landmarkCount,
                showDivider: false
            )
        }
    }
}

#Preview {
    ProfileContextView(
        name: "John",
        lastName: "Doe",
        landmarkCount: "10"
    )
}
