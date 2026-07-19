//
//  PlaceSearchSectionView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import SwiftUI

struct PlaceSearchSectionView: View {
    @Bindable private var viewModel: PlaceSearchViewModel
    private let selectedPlaceName: String?
    private let onSelect: (PlaceSearchResult) -> Void

    init(
        viewModel: PlaceSearchViewModel,
        selectedPlaceName: String?,
        onSelect: @escaping (PlaceSearchResult) -> Void
    ) {
        self.viewModel = viewModel
        self.selectedPlaceName = selectedPlaceName
        self.onSelect = onSelect
    }

    private var showsNoResults: Bool {
        viewModel.hasSearched && !viewModel.isSearching && viewModel.results.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: Constants.SystemImages.search)
                    .foregroundStyle(.secondary)

                TextField(Constants.Strings.searchPlace, text: $viewModel.query)
                    .autocorrectionDisabled()

                if viewModel.isSearching {
                    ProgressView()
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )

            if let selectedPlaceName {
                Label(selectedPlaceName, systemImage: Constants.SystemImages.visitedCheckmark)
                    .font(.caption)
                    .foregroundStyle(.green)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.results) { result in
                        Button {
                            onSelect(result)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(result.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)

                                Text(result.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6)
                        }

                        Divider()
                    }

                    if showsNoResults {
                        Text(Constants.Strings.noResults)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 6)
                    }
                }
            }

            Spacer(minLength: 0)

            Text(Constants.Strings.swipeForCoordinates)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .onChange(of: viewModel.query) {
            viewModel.queryChanged()
        }
    }
}

#Preview {
    PlaceSearchSectionView(
        viewModel: PlaceSearchViewModel(),
        selectedPlaceName: Mock.MockLandmarks.data[0].name,
        onSelect: { _ in }
    )
    .padding(16)
}
