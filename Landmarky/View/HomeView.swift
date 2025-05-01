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
                            subtitle: Constants.Strings.createLadnmarks
                        )
                    } else {
                        HomeCategoryScrollView(
                            categories: viewModel.categories,
                            landmarks: viewModel.filteredLandmarks()
                        )
                        .foregroundStyle(.primary)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle(Constants.Strings.homeTitle)
            .onAppear {
                viewModel.fetchLandmarks(modelContext: modelContext)
            }
            .searchable(text: $viewModel.searchText, prompt: Constants.Buttons.search)
        }
    }
}

#Preview {
    HomeView()
}
