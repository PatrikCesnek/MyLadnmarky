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
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(
                    Constants.Strings.home,
                    systemImage: Constants.SystemImages.house
                )
            }
            
            NavigationStack {
                MapView()
            }
            .tabItem {
                Label(
                    Constants.Strings.map,
                    systemImage: Constants.SystemImages.map
                )
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(
                    Constants.Strings.profile,
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
