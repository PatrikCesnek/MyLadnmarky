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
            if viewModel.user != nil {
                ProfileContentView(
                    isEditing: viewModel.isEditing,
                    landmarkCount: viewModel.landmarkCountText,
                    shouldShowAchievements: true,
                    firstName: $viewModel.firstName,
                    lastName: $viewModel.lastName
                )
            } else {
                ProfileContentView(
                    isEditing: viewModel.isEditing,
                    landmarkCount: viewModel.landmarkCountText,
                    firstName: $viewModel.firstName,
                    lastName: $viewModel.lastName
                )
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
