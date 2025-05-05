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
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
            if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retryAction: {
                        viewModel.displayLandmarks(modelContext: modelContext)
                    }
                )
                .padding(.horizontal, 16)
            } else {
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
        //                MapPitchToggle() unfortunately only works with elevation for mapStyle and that breaks loading, so for now it has to be commented out
        //                MapPitchToggle()
                        MapScaleView()
                    }
                    .mapStyle(
                        viewModel.changeMapStyle(.imagery)
                    )
                    
                    BottomPlusButton {
                        AddLandmarkView(
                            latitude: viewModel.getLandmarkLocation().latitude,
                            longitude: viewModel.getLandmarkLocation().longitude,
                            isDeleted: $viewModel.isDeleted
                            //TODO: - Get rid of isDeleted when I don't need it
                        )
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear{
            viewModel.displayLandmarks(modelContext: modelContext)
        }
        .navigationDestination(
            item: $viewModel.selectedLandmark,
            destination: { landmark in
                LandmarkDetailView(landmark: landmark)
            }
        )
        .toolbar(.hidden, for: .navigationBar)
        .tint(.green)
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
}
