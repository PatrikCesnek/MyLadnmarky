//
//  PhotoImportView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct PhotoImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var viewModel: PhotoImportViewModel

    init(viewModel: PhotoImportViewModel = PhotoImportViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.phase {
            case .intro:
                intro
            case .scanning:
                progress(Constants.Strings.scanningPhotos)
            case .denied:
                denied
            case .ready where viewModel.suggestions.isEmpty:
                message(
                    symbol: "photo.badge.checkmark",
                    title: Constants.Strings.noNewPlacesFound,
                    subtitle: Constants.Strings.noNewPlacesFoundSubtitle
                )
            case .ready:
                suggestionList
            case .importing:
                progress(Constants.Strings.addingPlaces)
            case .finished(let added):
                finished(added)
            case .failed(let error):
                message(symbol: "exclamationmark.triangle", title: Constants.Strings.errorTitle, subtitle: error)
            }
        }
        .navigationTitle(Constants.Strings.findPlacesInPhotos)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Constants.Buttons.cancel) { dismiss() }
                    .disabled(viewModel.phase == .importing)
            }
        }
        .interactiveDismissDisabled(viewModel.phase == .importing)
    }

    // MARK: - Phases

    private var intro: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                    .padding(.top, 32)

                Text(Constants.Strings.findPlacesInPhotos)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(Constants.Strings.photoImportIntro)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Label(Constants.Strings.photosStayOnDevice, systemImage: Constants.SystemImages.privacy)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.green)

                Button {
                    Task { await viewModel.scan(using: modelContext) }
                } label: {
                    Text(Constants.Strings.scanMyPhotos)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .prominentButtonStyle()
                .tint(.green)
                .padding(.top, 8)
            }
            .padding(24)
        }
    }

    private var denied: some View {
        VStack(spacing: 16) {
            message(
                symbol: "photo.badge.exclamationmark",
                title: Constants.Strings.photoAccessOff,
                subtitle: Constants.Strings.photoAccessOffSubtitle
            )
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                Button(Constants.Strings.openSettings) { openURL(settingsURL) }
                    .buttonStyle(.bordered)
                    .tint(.green)
            }
        }
    }

    private var suggestionList: some View {
        List {
            Section {
                ForEach($viewModel.suggestions) { $suggestion in
                    PhotoSuggestionRow(suggestion: $suggestion, library: viewModel.library)
                }
            } header: {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(Constants.Strings.foundPlaces(viewModel.suggestions.count))
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Spacer()
                        let allSelected = viewModel.selectedCount == viewModel.suggestions.count
                        Button(allSelected ? Constants.Strings.deselectAll : Constants.Strings.selectAll) {
                            viewModel.setAllSelected(!allSelected)
                        }
                        .font(.subheadline)
                        .tint(.green)
                    }
                    .textCase(nil)
                    if viewModel.access == .limited {
                        Text(Constants.Strings.limitedPhotoAccess)
                            .textCase(nil)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                Task { await viewModel.importSelected(using: modelContext) }
            } label: {
                Text(Constants.Strings.addPlacesCount(viewModel.selectedCount))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .prominentButtonStyle()
            .tint(.green)
            .disabled(viewModel.selectedCount == 0)
            .padding()
            .background(.bar)
        }
    }

    private func finished(_ added: Int) -> some View {
        VStack(spacing: 16) {
            message(
                symbol: "checkmark.circle.fill",
                title: Constants.Strings.placesAdded,
                subtitle: Constants.Strings.placesCount(added)
            )
            Button(Constants.Buttons.done) { dismiss() }
                .prominentButtonStyle()
                .tint(.green)
        }
        .sensoryFeedback(.success, trigger: added)
    }

    // MARK: - Building blocks

    private func progress(_ text: String) -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text(text)
                .foregroundStyle(.secondary)
            Label(Constants.Strings.photosStayOnDevice, systemImage: Constants.SystemImages.privacy)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func message(symbol: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 48))
                .foregroundStyle(.green)
            Text(title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
            Text(subtitle)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

private struct PhotoSuggestionRow: View {
    @Binding var suggestion: PhotoImportViewModel.Suggestion
    let library: any PhotoLibraryProviding

    @Environment(\.displayScale) private var displayScale
    @State private var thumbnail: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            Button {
                suggestion.isSelected.toggle()
            } label: {
                Image(systemName: suggestion.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(suggestion.isSelected ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(suggestion.name))
            .accessibilityAddTraits(suggestion.isSelected ? .isSelected : [])

            Group {
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.secondary.opacity(0.15)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                if suggestion.isResolvingName {
                    ProgressView()
                        .controlSize(.small)
                        .frame(height: 22)
                } else {
                    TextField(Constants.Strings.title, text: $suggestion.name)
                        .font(.headline)
                }

                HStack(spacing: 6) {
                    if let code = suggestion.place?.countryCode {
                        Text(CountryCatalog.flag(for: code))
                    }
                    Text(Constants.Strings.photosCount(suggestion.candidate.photoCount))
                    if let date = suggestion.candidate.firstDate {
                        Text(verbatim: "·")
                        Text(date, format: .dateTime.day().month(.abbreviated).year())
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Menu {
                    Picker(Constants.Strings.category, selection: $suggestion.category) {
                        ForEach(LandmarkCategory.predefinedCategories, id: \.localizedName) { category in
                            Label(category.localizedName, systemImage: HelperFunctions.getCategoryString(category.localizedName))
                                .tag(category.localizedName)
                        }
                    }
                } label: {
                    Label(suggestion.category, systemImage: HelperFunctions.getCategoryString(suggestion.category))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(HelperFunctions.changeAnnotationColor(categoryName: suggestion.category))
                }
            }
        }
        .padding(.vertical, 4)
        .opacity(suggestion.isSelected ? 1 : 0.55)
        .task(id: suggestion.candidate.representativePhotoID) {
            thumbnail = await library.thumbnail(
                for: suggestion.candidate.representativePhotoID,
                pixelSide: 64 * displayScale
            )
        }
    }
}

#Preview {
    NavigationStack {
        PhotoImportView()
    }
    .modelContainer(Mock.previewContainer())
}
