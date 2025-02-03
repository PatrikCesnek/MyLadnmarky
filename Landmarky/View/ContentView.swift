//
//  ContentView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import MapKit
import SwiftUI

struct ContentView: View {
   var viewModel = LandmarksViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label(Constants.strings.home, systemImage: "house") }
            MapView()
                .tabItem { Label(Constants.strings.map, systemImage: "map") }
            ProfileView()
                .tabItem { Label(Constants.strings.profile, systemImage: "person") }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Landmark.self, Profile.self])
}
