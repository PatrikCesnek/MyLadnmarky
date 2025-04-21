//
//  AddLandmarkView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import SwiftUI

struct AddLandmarkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddLandmarkViewModel
    
    init(
        latitude: Double,
        longitude: Double
    ) {
        _viewModel = State(
            initialValue: AddLandmarkViewModel(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HorizontalCenterView {
                        Button(
                            action: {},
                            label: {
                                LandmarkImageView(
                                    imageData: nil, // only for now
                                    cornerRadius: 0,
                                    isCircular: true
                                )
                                .frame(height: 150)
                                .foregroundStyle(Color.primary.opacity(0.8))
                            }
                        )
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
                Button(
                    action: {
                        viewModel.addLandmark(using: modelContext)
                        dismiss()
                    },
                    label: {
                        Text(Constants.Strings.save)
                            .font(.headline)
                    }
                )
            }
            .tint(.green)
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
