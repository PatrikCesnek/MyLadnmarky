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
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category.localizedName)
                                .font(.headline)
                                .padding(.leading, 10)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.landmarks(for: category), id: \.id) { landmark in
                                        LandmarkCard(landmark: landmark)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Landmarks")
            .onAppear {
                viewModel.fetchLandmarks(modelContext: modelContext)
            }
            .searchable(text: $viewModel.searchText, prompt: Constants.strings.search)
        }
    }
}

#Preview {
    HomeView()
}
