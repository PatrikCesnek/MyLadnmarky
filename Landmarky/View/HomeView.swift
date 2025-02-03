//
//  HomeView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Home - Categories & Search")
                    .navigationTitle(Constants.strings.homeTitle)
            }
            .searchable(text: .constant(Constants.strings.search), prompt: Constants.strings.search)
        }
    }
}

#Preview {
    HomeView()
}
