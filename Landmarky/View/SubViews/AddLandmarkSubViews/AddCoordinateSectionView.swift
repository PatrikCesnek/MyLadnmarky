//
//  AddCoordinateSectionView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct AddCoordinateSectionView: View {
    @Binding private var latitude: String
    @Binding private var longitude: String
    
    init(
        latitude: Binding<String>,
        longitude: Binding<String>
    ) {
        self._latitude = latitude
        self._longitude = longitude
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Constants.Strings.latitude + ":")
                TextField("", text: $latitude)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text(Constants.Strings.longitude + ":")
                TextField("", text: $longitude)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

#Preview {
    @Previewable @State var latitude: String = "\(Constants.DefaultLandmarkLocation.defaultLat)"
    @Previewable @State var longitude: String = "\(Constants.DefaultLandmarkLocation.defaultLon)"
    
    AddCoordinateSectionView(
        latitude: $latitude,
        longitude: $longitude
    )
}
