//
//  AddLandmarkView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import PhotosUI
import SwiftUI
import UIKit

struct AddLandmarkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddLandmarkViewModel

    @State private var selectedUIImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?

    @Binding private var isDeleted: Bool
    private let onSave: () -> Void

    init(
        latitude: Double,
        longitude: Double,
        landmark: Landmark? = nil,
        isDeleted: Binding<Bool>,
        onSave: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: AddLandmarkViewModel(
                landmark: landmark,
                latitude: latitude,
                longitude: longitude
            )
        )
        self._isDeleted = isDeleted
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retryAction: {
                        if viewModel.isEdit {
                            viewModel.editLandmark(using: modelContext)
                        } else {
                            viewModel.addLandmark(using: modelContext)
                        }
                    }
                )
                .padding(.horizontal, 16)
            } else {
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
                            TextEditor(
                                text: $viewModel.description
                            )
                            .frame(minHeight: 100)
                        },
                        header: { Text(Constants.Strings.description) }
                    )

                    Section(
                        content: {
                            LocationCarouselView(
                                latitude: $viewModel.latText,
                                longitude: $viewModel.lonText,
                                title: $viewModel.title
                            )
                        },
                        header: { Text(Constants.Strings.location) }
                    )

                    if viewModel.showsWishlistToggle {
                        Section(
                            content: {
                                Toggle(Constants.Strings.wantToVisit, isOn: $viewModel.isWishlisted.animation())
                            },
                            header: { Text(Constants.Strings.wishlist) }
                        )
                    }

                    if !viewModel.isWishlisted {
                        Section(
                            content: {
                                Toggle(Constants.Strings.addVisitDate, isOn: $viewModel.hasVisitDate.animation())
                                if viewModel.hasVisitDate {
                                    DatePicker(
                                        Constants.Strings.visitDateLabel,
                                        selection: $viewModel.visitDate,
                                        displayedComponents: .date
                                    )
                                }
                            },
                            header: { Text(Constants.Strings.visitDateLabel) }
                        )
                    }

                    if viewModel.isEdit {
                        Section {
                            CenterView {
                                Button(Constants.Buttons.delete) {
                                    viewModel.deleteLandmark(
                                        using: modelContext,
                                        landmark: viewModel.landmark
                                    )
                                    if viewModel.error == nil {
                                        isDeleted = true
                                    }
                                }
                                .foregroundStyle(Color.red)
                            }
                        }
                    }
                }
                .navigationTitle(Text(Constants.Strings.addLandmarkTitle))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(
                        action: {
                            if viewModel.isEdit {
                                viewModel.editLandmark(using: modelContext)
                            } else {
                                viewModel.addLandmark(using: modelContext)
                            }
                        },
                        label: {
                            Image(systemName: Constants.SystemImages.editSaveButtonImage)
                                .font(.headline)
                        }
                    )
                    .buttonStyle(.glassProminent)
                    .tint(.green)
                }
            }
        }
        .onChange(of: viewModel.didSave) { _, saved in
            if saved {
                onSave()
                dismiss()
            }
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
