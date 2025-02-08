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
            Map(
                coordinateRegion: Binding<MKCoordinateRegion>(
                    get: { viewModel.userRegion },
                    set: { location in viewModel.updateUserLocation(location.center) }
                ),
                annotationItems: viewModel.validLandmarks
            ) { landmark in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: landmark.latitude ?? 0, longitude: landmark.longitude ?? 0)) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                }
            }
            .ignoresSafeArea(edges: [.top, .horizontal])
            
            VStack(alignment: .trailing) {
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {}, label: { Image(systemName: "plus") })
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
