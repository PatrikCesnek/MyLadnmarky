//
//  AddLandmarkView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import PhotosUI
import SwiftUI

struct AddLandmarkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddLandmarkViewModel

    @State private var selectedUIImage: UIImage?
    @State private var showCameraView = false
    @State private var showImagePicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?

    init(latitude: Double, longitude: Double) {
        _viewModel = State(initialValue: AddLandmarkViewModel(latitude: latitude, longitude: longitude))
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HorizontalCenterView {
                        Button {
                            viewModel.showPhotoSourceSheet = true
                        } label: {
                            LandmarkImageView(
                                imageData: viewModel.selectedImageData,
                                cornerRadius: 16,
                                isCircular: false
                            )
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.primary.opacity(0.8))
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section(
                    content: {
                        TitleSectionView(
                            title: $viewModel.title,
                            category: $viewModel.category,
                            categoryString: $viewModel.categoryString,
                            isCustomCategory: viewModel.isCustomCategory
                        )
                    },
                    header: { Text(Constants.Strings.title) }
                )
                
                Section(
                    content: {
                        AddCoordinateSectionView(
                            latitude: $viewModel.latText,
                            longitude: $viewModel.lonText
                        )
                    },
                    header: { Text(Constants.Strings.location) }
                )
                
                Section(
                    content: {
                        TextEditor(
                            text: $viewModel.description
                        )
                        .frame(minHeight: 100)
                    },
                    header: { Text(Constants.Strings.description) }
                )
            }
            .navigationTitle(Text(Constants.Strings.addLandmarkTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewModel.addLandmark(using: modelContext)
                    dismiss()
                }) {
                    Text(Constants.Strings.save)
                        .font(.headline)
                }
            }
            .tint(.green)
        }
        .confirmationDialog(Constants.Strings.choosePhotoSource, isPresented: $viewModel.showPhotoSourceSheet) {
            Button(Constants.Strings.chooseFromGallery) {
                viewModel.showPhotoPicker = true
            }
            Button(Constants.Strings.takePhoto) {
                viewModel.showCamera = true
            }
            Button(Constants.Strings.cancel, role: .cancel) {}
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
    }
}

#Preview {
    NavigationView {
        AddLandmarkView(
            latitude: Constants.DefaultLandmarkLocation.defaultLat,
            longitude: Constants.DefaultLandmarkLocation.defaultLon
        )
    }
}
