//
//  LandmarkDetailView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 14/03/2025.
//

import MapKit
import SwiftUI

struct LandmarkDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var isDeleted = false
    @State private var isShowingEditView = false

    private let landmark: Landmark

    init(landmark: Landmark) {
        self.landmark = landmark
    }

    var body: some View {
        VStack {
            ZStack {
                DetailMapView(
                    latitude: HelperFunctions.getCoordinate(.lat, landmark.latitude),
                    longitude: HelperFunctions.getCoordinate(.lon, landmark.longitude),
                    name: landmark.name,
                    category: landmark.category
                )
                .frame(height: 300)
                .background(ignoresSafeAreaEdges: [.top, .horizontal])
            }

            LandmarkImageView(
                imageData: landmark.image,
                cornerRadius: 0,
                isCircular: true
            )
            .offset(y: -130)
            .padding(.bottom, -130)
            .frame(width: 250, height: 100)
            .shadow(radius: 8)

            LandmarkDetailInfoView(
                title: landmark.name,
                category: landmark.category,
                description: landmark.landmarkDescription
            )
            .padding(16)

            Spacer()

            PrimaryButton(
                action: {
                    NavigationHelper.startNavigation(
                        to: HelperFunctions.getLocation(landmark: landmark),
                        name: landmark.name
                    )
                },
                text: Constants.Buttons.navigate
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        landmark.isFavorite.toggle()
                        try? modelContext.save()
                    } label: {
                        Image(systemName: landmark.isFavorite ? "heart.fill" : "heart")
                            .font(.headline)
                            .foregroundStyle(landmark.isFavorite ? .red : .primary)
                    }
                    .buttonStyle(.borderless)

                    Button(action: {
                        isShowingEditView = true
                    }) {
                        Image(systemName: Constants.SystemImages.editButtonImage)
                            .font(.headline)
                            .foregroundStyle(Color.green)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel(Text(Constants.Buttons.edit))
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingEditView) {
            NavigationStack {
                AddLandmarkView(
                    latitude: HelperFunctions.getCoordinate(.lat, landmark.latitude),
                    longitude: HelperFunctions.getCoordinate(.lon, landmark.longitude),
                    landmark: landmark,
                    isDeleted: $isDeleted
                )
            }
        }
        .onChange(of: isDeleted) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkDetailView(landmark: Mock.MockLandmarks.data[0])
    }
}
