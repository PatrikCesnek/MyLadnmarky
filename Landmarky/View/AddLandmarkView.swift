//
//  AddLandmarkView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import SwiftUI

struct AddLandmarkView: View {
    @State private var title: String
    @State private var latitude: String
    @State private var longitude: String
    @State private var description: String
    private let saveAction: () -> Void
    
    init(
        title: String,
        latitude: String,
        longitude: String,
        description: String,
        saveAction: @escaping () -> Void
    ) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.saveAction = saveAction
    }
    
    var body: some View {
        VStack {
            VStack {
                Form {
                    Section(
                        content: { TextField(Constants.Strings.title, text: $title) },
                        header: { Text(Constants.Strings.title) }
                    )
                    
                    Section(
                        content: {
                            VStack {
                                HStack {
                                    Text(Constants.Strings.latitude + ":")
                                    TextField(Constants.Strings.location, text: $latitude)
                                }
                                HStack {
                                    Text(Constants.Strings.longitude + ":")
                                    TextField(Constants.Strings.location, text: $longitude)
                                }
                            }
                        },
                        header: { Text(Constants.Strings.location) }
                    )
                    
                    Section(
                        content: {
                            TextEditor(
                                text: Binding(
                                    get: { description },
                                    set: { description = $0 }
                                )
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
                        action: saveAction,
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
            title: Mock.MockLandmarks.data[0].name,
            latitude: String(Constants.DefaultLandmarkLocation.defaultLat),
            longitude: String(Constants.DefaultLandmarkLocation.defaultLon),
            description: Mock.MockLandmarks.mockDescription,
            saveAction: {}
        )
    }
}
