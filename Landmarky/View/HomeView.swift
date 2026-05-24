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
        Group {
            if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retryAction: {
                        viewModel.fetchLandmarks(modelContext: modelContext)
                    }
                )
                .padding(.horizontal, 16)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                
                                LoadingView(lineWidth: 16)
                                    .frame(width: 200)
                        
                                Spacer()
                            }
                            .padding(16)
                            
                        } else if viewModel.landmarks.isEmpty {
                            EmptyView(
                                title: Constants.Strings.noLandmarks,
                                subtitle: Constants.Strings.createLandmarks
                            )
                        } else {
                            if !viewModel.favoriteLandmarks.isEmpty {
                                FavoritesScrollView(landmarks: viewModel.favoriteLandmarks)
                            }

                            HomeCategoryScrollView(
                                categories: viewModel.categories,
                                landmarks: viewModel.filteredLandmarks()
                            )
                            .foregroundStyle(.primary)
                        }
                    }
                }
                .navigationTitle(Constants.Strings.homeTitle)
                .onAppear {
                    viewModel.fetchLandmarks(modelContext: modelContext)
                }
                .searchable(text: $viewModel.searchText, prompt: Constants.Buttons.search)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
