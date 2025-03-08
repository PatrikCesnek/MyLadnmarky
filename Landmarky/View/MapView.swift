//
//  MapView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    var viewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(initialPosition: viewModel.cameraPosition) {
                UserAnnotation()
                
                ForEach(viewModel.landmarks, id: \.id) { landmark in
                    Annotation(
                        landmark.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: landmark.latitude ?? Constants.DefaultLandmarkLocation.defaultLat,
                            longitude: landmark.longitude ?? Constants.DefaultLandmarkLocation.defaultLon
                        )
                    ) {
                        Image(systemName: Constants.SystemImages.mappin)
                            .foregroundColor(.green)
                            .font(.title)
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(viewModel.changeMapStyle(.imagery(elevation: .realistic)))
            
            VStack(alignment: .trailing) {
                Spacer()
                
                HStack {
                    Spacer()
                    Button(
                        action: {
                            viewModel.addLandmark()
                        },
                        label: {
                            Image(systemName: Constants.SystemImages.plus)
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .clipShape(Circle())
                }
            }
            .padding()
        }
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
}
