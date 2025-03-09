//
//  HomeView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            if viewModel.landmarks.isEmpty {
                EmptyView(title: Constants.Strings.noLandmarks, subtitle: nil)
            }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    HomeCategoryScrollView(
                        categories: viewModel.categories,
                        landmarks: viewModel.landmarks
                    )
                }
                .padding(.vertical)
            }
            .navigationTitle(Constants.Strings.homeTitle)
            .onAppear {
                viewModel.fetchLandmarks(modelContext: modelContext)
            }
            .searchable(text: $viewModel.searchText, prompt: Constants.Strings.search)
        }
    }
}

#Preview {
    HomeView()
}
