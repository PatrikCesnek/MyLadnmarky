//
//  MapView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var viewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            Map() {
                UserAnnotation()
                
                ForEach(viewModel.landmarks, id: \.id) { landmark in
                    LandmarkAnnotation(landmark: landmark) {
                        viewModel.selectedLandmark = landmark
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(
                viewModel.changeMapStyle(
                    .imagery(elevation: .realistic)
                )
            )
            
            BottomPlusButton {
                AddLandmarkView(
                    latitude: viewModel.getLandmarkLocation().latitude,
                    longitude: viewModel.getLandmarkLocation().longitude
                )
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 24)
        }
        .navigationDestination(
            item: $viewModel.selectedLandmark,
            destination: { landmark in
                LandmarkDetailView(landmark: landmark)
            }
        )
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
}
