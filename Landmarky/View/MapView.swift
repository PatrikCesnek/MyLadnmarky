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
