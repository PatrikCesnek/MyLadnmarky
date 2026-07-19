//
//  ContentView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(
                    Constants.Buttons.home,
                    systemImage: Constants.SystemImages.house
                )
            }
            
            NavigationStack {
                MapView()
            }
            .tabItem {
                Label(
                    Constants.Buttons.map,
                    systemImage: Constants.SystemImages.map
                )
            }

            NavigationStack {
                DiaryView()
            }
            .tabItem {
                Label(
                    Constants.Buttons.diary,
                    systemImage: Constants.SystemImages.book
                )
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(
                    Constants.Buttons.profile,
                    systemImage: Constants.SystemImages.person
                )
            }
        }
        .onAppear {
            WishlistVisitService.autoVisitNearby(using: modelContext)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                WishlistVisitService.autoVisitNearby(using: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Landmark.self, Profile.self, Trip.self])
}
