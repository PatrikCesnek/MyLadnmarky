//
//  AddLandmarkView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import SwiftUI

struct AddLandmarkView: View {
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
                            TextField(
                                Constants.Strings.title,
                                text: $viewModel.title
                            )
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
                        action: { viewModel.addLandmark() },
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
