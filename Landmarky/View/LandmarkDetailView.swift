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
    @State private var isDeleted = false
    
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
            .frame(width: 300, height: 100)
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
//        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing,
                content: {
                    NavigationLink(
                        destination: AddLandmarkView(
                            latitude: HelperFunctions.getCoordinate(.lat, landmark.latitude),
                            longitude: HelperFunctions.getCoordinate(.lon, landmark.longitude),
                            landmark: landmark,
                            isDeleted: $isDeleted
                        ),
                        label: {
                            Image(systemName: Constants.SystemImages.editButtonImage
                            )
                            .foregroundStyle(Color.green)
                        }
                    )
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkDetailView(landmark: Mock.MockLandmarks.data[0])
    }
}
