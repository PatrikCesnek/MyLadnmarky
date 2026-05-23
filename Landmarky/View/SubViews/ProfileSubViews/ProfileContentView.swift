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
    private let badgeStats: BadgeStats?
    private let badgeItems: [BadgeItem]
    @Binding private var firstName: String
    @Binding private var lastName: String?

    init(
        isEditing: Bool,
        landmarkCount: String?,
        shouldShowAchievements: Bool = false,
        badgeStats: BadgeStats? = nil,
        badgeItems: [BadgeItem] = [],
        firstName: Binding<String>,
        lastName: Binding<String?>
    ) {
        self.isEditing = isEditing
        self.landmarkCount = landmarkCount
        self.shouldShowAchievements = shouldShowAchievements
        self.badgeStats = badgeStats
        self.badgeItems = badgeItems
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

            if shouldShowAchievements, let stats = badgeStats {
                Section {
                    ProfileStatsView(
                        landmarkCount: stats.landmarkCount,
                        countriesCount: stats.uniqueCountries.count,
                        badgesEarned: badgeItems.filter(\.isEarned).count,
                        totalBadges: badgeItems.count
                    )
                }

                Section(Constants.Strings.achievementsTitle) {
                    BadgeGridView(items: badgeItems)
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
