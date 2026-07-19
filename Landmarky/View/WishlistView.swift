//
//  WishlistView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import SwiftUI

struct WishlistView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WishlistViewModel()

    var body: some View {
        Group {
            if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retryAction: {
                        viewModel.fetchWishlist(modelContext: modelContext)
                    }
                )
                .padding(.horizontal, 16)
            } else if viewModel.landmarks.isEmpty {
                EmptyView(
                    title: Constants.Strings.emptyWishlist,
                    subtitle: Constants.Strings.emptyWishlistSubtitle
                )
            } else {
                List {
                    ForEach(viewModel.landmarks) { landmark in
                        NavigationLink {
                            LandmarkDetailView(landmark: landmark)
                        } label: {
                            WishlistRowView(landmark: landmark)
                        }
                        .swipeActions {
                            Button {
                                viewModel.markVisited(landmark, using: modelContext)
                            } label: {
                                Label(
                                    Constants.Strings.markAsVisited,
                                    systemImage: Constants.SystemImages.editSaveButtonImage
                                )
                            }
                            .tint(.green)
                        }
                    }
                }
            }
        }
        .navigationTitle(Constants.Strings.wishlist)
        .onAppear {
            viewModel.fetchWishlist(modelContext: modelContext)
        }
    }
}

private struct WishlistRowView: View {
    let landmark: Landmark

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: HelperFunctions.getCategoryString(landmark.category))
                .foregroundStyle(HelperFunctions.changeAnnotationColor(categoryName: landmark.category))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(landmark.name)
                    .font(.headline)

                Text(landmark.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WishlistView()
            .modelContainer(for: [Landmark.self], inMemory: true)
    }
}
