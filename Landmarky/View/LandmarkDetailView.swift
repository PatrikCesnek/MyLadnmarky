//
//  LandmarkDetailView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 14/03/2025.
//

import SwiftUI

struct LandmarkDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                    name: landmark.name
                )
                .frame(height: 300)
                .background(ignoresSafeAreaEdges: [.top, .horizontal])
                
                BackButtonView(action: { dismiss() })
                    .offset(y: -150)
                    .padding(8)
            }
            
            //TODO: - Use correct landmark Image
//            CircleImage(image: landmark.image)
            CircleImage(image: Mock.MockLandmarks.mockImage)
                .offset(y: -130)
                .padding(.bottom, -130)
                .frame(width: 300, height: 100)
            
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
            
            Button(
                action: {},
                label: {
                    Text(Constants.Strings.navigate)
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                }
            )
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .tint(.green)
            .padding(8)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    LandmarkDetailView(landmark: Mock.MockLandmarks.data[0])
}
