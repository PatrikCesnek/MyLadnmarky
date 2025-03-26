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
            VStack {
                Form {
                    Section(
                        content: {
                            VStack {
                                TextField(
                                    Constants.Strings.title,
                                    text: $viewModel.title
                                )
                                
                                Picker(Constants.Strings.category, selection: $viewModel.category) {
                                    ForEach(LandmarkCategory.predefinedCategories, id: \.self) { category in
                                        Text(category.localizedName).tag(category.localizedName)
                                    }
                                    Text(Constants.Strings.custom).tag(Constants.Strings.custom)
                                }
                                .pickerStyle(.menu)
                                
                                if viewModel.isCustomCategory {
                                    TextField(Constants.Strings.customCategory, text: $viewModel.categoryString)
                                }
                            }
                        },
                        header: { Text(Constants.Strings.title) }
                    )
                    
                    Section(
                        content: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(Constants.Strings.latitude + ":")
                                    TextField("", text: $viewModel.latText)
                                        .keyboardType(.decimalPad)
                                }
                                
                                HStack {
                                    Text(Constants.Strings.longitude + ":")
                                    TextField("", text: $viewModel.lonText)
                                        .keyboardType(.decimalPad)
                                }
                            }
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
                        }
                    )
                }
                .tint(.green)
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
