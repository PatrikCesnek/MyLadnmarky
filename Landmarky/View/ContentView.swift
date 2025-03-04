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
                .tabItem {
                    Label(
                        Constants.strings.home,
                        systemImage: Constants.SystemImages.house
                    )
                }
            MapView()
                .tabItem {
                    Label(
                        Constants.strings.map,
                        systemImage: Constants.SystemImages.map
                    )
                }
            ProfileView()
                .tabItem {
                    Label(
                        Constants.strings.profile,
                        systemImage: Constants.SystemImages.person
                    )
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Landmark.self, Profile.self])
}
