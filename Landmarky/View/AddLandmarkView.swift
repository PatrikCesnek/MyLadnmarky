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
    @StateObject var viewModel: AddLandmarkViewModel

    @State private var selectedUIImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    @Binding private var isDeleted: Bool

    init(
        latitude: Double,
        longitude: Double,
        landmark: Landmark? = nil,
        isDeleted: Binding<Bool>
    ) {
        _viewModel = StateObject(
            wrappedValue: AddLandmarkViewModel(
                landmark: landmark,
                latitude: latitude,
                longitude: longitude
            )
        )
        self._isDeleted = isDeleted
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
                            .frame(width: 180, height: 150)
                            .foregroundStyle(Color.primary.opacity(0.8))
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section(
                    content: {
                        TitleSectionView(
                            title: $viewModel.title,
                            category: $viewModel.selectedCategory,
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
                
                if viewModel.isEdit {
                    Section(
                        content: {
                            CenterView{
                                Button(Constants.Buttons.delete){
                                    viewModel.deleteLandmark(
                                        using: modelContext,
                                        landmark: viewModel.landmark
                                    )
                                    isDeleted = true
                                    dismiss()
                                }
                                .foregroundStyle(Color.red)
                            }
                        }
                    )
                }
            }
            .navigationTitle(Text(Constants.Strings.addLandmarkTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    if viewModel.isEdit {
                        viewModel.editLandmark(using: modelContext)
                    } else {
                        viewModel.addLandmark(using: modelContext)
                    }
                    dismiss()
                }) {
                    Text(Constants.Buttons.save)
                        .font(.headline)
                }
            }
            .tint(.green)
        }
        .confirmationDialog(
            Constants.Strings.choosePhotoSource,
            isPresented: $viewModel.showPhotoSourceSheet
        ) {
            Button(Constants.Buttons.chooseFromGallery) {
                viewModel.showPhotoPicker = true
            }
            Button(Constants.Buttons.takePhoto) {
                viewModel.showCamera = true
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
    }
}

#Preview {
    @Previewable @State var isDeleted = false
    NavigationView {
        AddLandmarkView(
            latitude: Constants.DefaultLandmarkLocation.defaultLat,
            longitude: Constants.DefaultLandmarkLocation.defaultLon,
            isDeleted: $isDeleted
        )
    }
}
