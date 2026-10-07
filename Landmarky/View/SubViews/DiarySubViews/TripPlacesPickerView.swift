//
//  TripPlacesPickerView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftData
import SwiftUI

/// Multi-select list of visited places, with the ones matching the trip dates on top.
struct TripPlacesPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<Landmark> { $0.isWishlisted == false }, sort: \Landmark.name)
    private var landmarks: [Landmark]

    @Binding var selection: Set<UUID>
    let startDate: Date
    let endDate: Date?

    @State private var searchText = ""

    private var suggested: [Landmark] {
        filtered(TripPlaces.suggestions(startDate: startDate, endDate: endDate, from: landmarks))
    }

    private var others: [Landmark] {
        let suggestedIDs = Set(suggested.map(\.id))
        return filtered(landmarks.filter { !suggestedIDs.contains($0.id) })
    }

    var body: some View {
        List {
            if landmarks.isEmpty {
                Text(Constants.Strings.noLandmarks)
                    .foregroundStyle(.secondary)
            }

            if !suggested.isEmpty {
                Section(Constants.Strings.suggestedForDates) {
                    ForEach(suggested) { row(for: $0) }
                }
            }

            if !others.isEmpty {
                Section(Constants.Strings.allPlaces) {
                    ForEach(others) { row(for: $0) }
                }
            }
        }
        .searchable(text: $searchText, prompt: Constants.Buttons.search)
        .navigationTitle(Constants.Strings.places)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(Constants.Buttons.done) { dismiss() }
                    .fontWeight(.semibold)
            }
        }
    }

    private func row(for landmark: Landmark) -> some View {
        let isSelected = selection.contains(landmark.id)

        return Button {
            if isSelected {
                selection.remove(landmark.id)
            } else {
                selection.insert(landmark.id)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: HelperFunctions.getCategoryString(landmark.category))
                    .foregroundStyle(HelperFunctions.changeAnnotationColor(categoryName: landmark.category))
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(landmark.name)
                        .foregroundStyle(.primary)
                    if let visitDate = landmark.visitDate {
                        Text(visitDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .green : .secondary)
            }
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func filtered(_ items: [Landmark]) -> [Landmark] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return items }
        return items.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}

#Preview {
    @Previewable @State var selection: Set<UUID> = []
    NavigationStack {
        TripPlacesPickerView(selection: $selection, startDate: Date(), endDate: nil)
    }
    .modelContainer(for: AppSchema.models, inMemory: true)
}
