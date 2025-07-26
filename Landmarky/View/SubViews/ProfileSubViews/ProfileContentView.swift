//
//  ProfileContentView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 26/07/2025.
//

import SwiftUI

struct ProfileContentView: View {
    private let isEditing: Bool
    private let landmarkCount: String?
    private let shouldShowAchievements: Bool
    @Binding private var firstName: String
    @Binding private var lastName: String?

    init(
        isEditing: Bool,
        landmarkCount: String?,
        shouldShowAchievements: Bool = false,
        firstName: Binding<String>,
        lastName: Binding<String?>
    ) {
        self.isEditing = isEditing
        self.landmarkCount = landmarkCount
        self.shouldShowAchievements = shouldShowAchievements
        self._firstName = firstName
        self._lastName = lastName
    }

    var body: some View {
        Form {
            CenterView {
                LandmarkImageView(
                    imageData: nil, // only for now
                    cornerRadius: 0,
                    isCircular: true,
                    isProfile: true
                )
                .frame(height: 150)
            }
            .listRowBackground(Color.clear)

            Section(Constants.Buttons.profile) {
                if !isEditing {
                    ProfileContextView(
                        name: firstName,
                        lastName: lastName,
                        landmarkCount: landmarkCount
                    )
                } else {
                    ProfileEditContextView(
                        firstName: $firstName,
                        lastName: $lastName
                    )
                }
            }

            if shouldShowAchievements {
                Section(Constants.Strings.achievementsTitle) {
                    VStack {
                        ProfileCellView(
                            text: Constants.Strings.noAchievements,
                            showDivider: false
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var name: String = "John"
    @Previewable @State var lastName: String? = "Doe"
    ProfileContentView(
        isEditing: false,
        landmarkCount: "5",
        firstName: $name,
        lastName: $lastName
    )
}
