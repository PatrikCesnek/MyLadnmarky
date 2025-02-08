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
            Map(position: Binding<MapCameraPosition>(
                get: { viewModel.cameraPosition },
                set: {  location in viewModel.updateUserLocation(location.region?.center) }
            ))
            .ignoresSafeArea()
            
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
