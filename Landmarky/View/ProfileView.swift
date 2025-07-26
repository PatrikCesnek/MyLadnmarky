//
//  ProfileView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
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
                        if !viewModel.isEditing {
                            ProfileContextView(
                                name: user.name,
                                lastName: user.lastName,
                                landmarkCount: viewModel.landmarkCountText ?? Constants.Strings.noLandmarks
                            )
                        } else {
                            ProfileEditContextView(
                                firstName: $viewModel.firstName,
                                lastName: $viewModel.lastName
                            )
                        }
                    }
                    
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
        .navigationTitle(Constants.Buttons.profile)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(
                action: {
                    viewModel.editProfile(using: modelContext)
                },
                label: {
                    viewModel.isEditing
                    ? Image(systemName: Constants.SystemImages.editSaveButtonImage)
                    : Image(systemName: Constants.SystemImages.editButtonImage)
                }
            )
            .tint(.green)
            .fontWeight(.bold)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
