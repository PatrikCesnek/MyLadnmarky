//
//  ProfileView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import PhotosUI
import SwiftUI
import UIKit

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProfileViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading) {
            ProfileContentView(
                isEditing: viewModel.isEditing,
                landmarkCount: viewModel.landmarkCountText,
                shouldShowAchievements: viewModel.user != nil,
                badgeStats: viewModel.badgeStats,
                badgeItems: viewModel.badgeItems,
                firstName: $viewModel.firstName,
                lastName: $viewModel.lastName,
                imageData: $viewModel.selectedImageData,
                choosePhotoAction: {
                    viewModel.showPhotoSourceSheet = true
                }
            )
        }
        .onAppear {
            viewModel.loadProfile(using: modelContext)
        }
        .alert(
            Constants.Strings.errorTitle,
            isPresented: Binding(
                get: { viewModel.alertText != nil },
                set: { isPresented in
                    if !isPresented { viewModel.alertText = nil }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertText ?? "")
        }
        .confirmationDialog(
            Constants.Strings.choosePhotoSource,
            isPresented: $viewModel.showPhotoSourceSheet
        ) {
            Button(Constants.Buttons.chooseFromGallery) {
                viewModel.showPhotoPicker = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(Constants.Buttons.takePhoto) {
                    viewModel.showCamera = true
                }
            }
            if viewModel.selectedImageData != nil {
                Button(Constants.Strings.removePhoto, role: .destructive) {
                    viewModel.selectedImageData = nil
                    selectedPhotoItem = nil
                }
            }
            Button(Constants.Buttons.cancel, role: .cancel) {}
        }
        .photosPicker(
            isPresented: $viewModel.showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task { await viewModel.loadPhoto(from: newItem) }
        }
        .sheet(isPresented: $viewModel.showCamera) {
            ImagePickerView(sourceType: .camera) { image in
                viewModel.handlePickedImage(image)
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
