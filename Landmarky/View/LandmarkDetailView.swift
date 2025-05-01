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
                    latitude: landmark.latitude ?? Constants.DefaultLandmarkLocation.defaultLat,
                    longitude: landmark.longitude ?? Constants.DefaultLandmarkLocation.defaultLon,
                    name: landmark.name,
                    category: landmark.category
                )
                .frame(height: 300)
                .background(ignoresSafeAreaEdges: [.top, .horizontal])
                
                HStack {
                    BackButtonView(action: { dismiss() })
                                            
                    Spacer()
                    
                    EditButtonView(
                        destination: {
                            AddLandmarkView(
                                latitude: landmark.latitude ?? Constants.DefaultLandmarkLocation.defaultLat,
                                longitude: landmark.longitude ?? Constants.DefaultLandmarkLocation.defaultLon,
                                landmark: landmark,
                                isDeleted: $isDeleted
                            )
                            .onDisappear {
                                if isDeleted {
                                    dismiss()
                                }
                            }
                        },
                        showImage: true
                    )
                }
                .offset(y: -140)
                .padding(8)
                
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
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(landmark.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(landmark.category)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    if let description = landmark.landmarkDescription {
                        Text(description)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            
            Spacer()
            
            PrimaryButton(
                action: {
                    NavigationHelper.startNavigation(
                        to: CLLocationCoordinate2D(
                            latitude: landmark.latitude ?? Constants.DefaultLandmarkLocation.defaultLat,
                            longitude: landmark.longitude ?? Constants.DefaultLandmarkLocation.defaultLon
                        ),
                        name: landmark.name
                    )
                },
                text: Constants.Strings.navigate
            )
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    LandmarkDetailView(landmark: Mock.MockLandmarks.data[0])
}
