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
    @State private var isShowingPhotoImport = false
    @State private var reviewYear: ReviewYear?

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

                            Button {
                                isShowingPhotoImport = true
                            } label: {
                                Label(Constants.Strings.findPlacesInPhotos, systemImage: Constants.SystemImages.photoImport)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                            .prominentButtonStyle()
                            .tint(.green)
                            .padding(.horizontal)
                        } else {
                            if let year = viewModel.featuredReviewYear {
                                Button {
                                    reviewYear = ReviewYear(year: year)
                                } label: {
                                    Label(Constants.Strings.yearReviewReady(year), systemImage: "sparkles")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .foregroundStyle(.white)
                                        .background(ShareCardStyle.background, in: RoundedRectangle(cornerRadius: 18))
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }

                            if let nextBadge = viewModel.nextBadge {
                                NextBadgeCard(item: nextBadge)
                            }

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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            VisitedCountriesView()
                        } label: {
                            Image(systemName: Constants.SystemImages.globe)
                        }
                        .accessibilityLabel(Text(Constants.Strings.yourWorld))
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            WishlistView()
                        } label: {
                            Image(systemName: Constants.SystemImages.wishlist)
                        }
                        .accessibilityLabel(Text(Constants.Strings.wishlist))
                    }
                }
                .onAppear {
                    viewModel.fetchLandmarks(modelContext: modelContext)
                }
                .searchable(text: $viewModel.searchText, prompt: Constants.Buttons.search)
                .fullScreenCover(item: $reviewYear) { review in
                    YearInReviewView(preferredYear: review.year)
                }
                .sheet(isPresented: $isShowingPhotoImport, onDismiss: {
                    viewModel.fetchLandmarks(modelContext: modelContext)
                }) {
                    NavigationStack {
                        PhotoImportView()
                    }
                }
            }
        }
    }
}

private struct ReviewYear: Identifiable {
    let year: Int
    var id: Int { year }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
