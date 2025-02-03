//
//  MapView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationView {
            Text("Map View with Annotations")
                .navigationTitle(Constants.strings.map)
        }
    }
}

#Preview {
    MapView()
}
