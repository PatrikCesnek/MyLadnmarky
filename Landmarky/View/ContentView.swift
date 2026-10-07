//
//  ContentView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import Combine
import MapKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var celebration = BadgeCelebrationViewModel()

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
        .overlay {
            if let badge = celebration.current {
                BadgeUnlockView(
                    badge: badge,
                    position: celebration.position,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            celebration.dismissCurrent()
                        }
                    },
                    accessory: {
                        ShareCardButton(title: badge.displayName, contentID: badge, style: .labeled) {
                            BadgeShareCard(badge: badge)
                        }
                        .buttonStyle(.bordered)
                        .tint(badge.tier.color)
                    }
                )
                .transition(.opacity)
            }
        }
        .onAppear {
            celebration.configure(context: modelContext)
            WishlistVisitService.autoVisitNearby(using: modelContext)
            celebration.refresh()
        }
        .task {
            let backfill = CountryBackfillService(context: modelContext)
            _ = try? backfill.backfillFromNames()
            _ = try? await backfill.backfillByGeocoding()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                WishlistVisitService.autoVisitNearby(using: modelContext)
                celebration.refresh()
            }
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: ModelContext.didSave)
                .receive(on: RunLoop.main)
        ) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                celebration.refresh()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AppSchema.models, inMemory: true)
}
