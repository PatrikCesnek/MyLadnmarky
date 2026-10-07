//
//  VisitedCountriesView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftData
import SwiftUI

struct VisitedCountriesView: View {
    @Query(filter: #Predicate<Landmark> { $0.isWishlisted == false })
    private var landmarks: [Landmark]

    private var summary: VisitedCountriesSummary {
        VisitedCountriesSummary(landmarks: Constants.showsMockData ? Mock.MockLandmarks.data : landmarks)
    }

    var body: some View {
        let summary = summary

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header(summary)

                LoadingWorldMapView(visitedCodes: summary.codes)
                    .padding(12)
                    .background(.secondary.opacity(0.06), in: RoundedRectangle(cornerRadius: 20))

                if summary.countries.isEmpty {
                    EmptyView(
                        title: Constants.Strings.noCountriesYet,
                        subtitle: Constants.Strings.noCountriesYetSubtitle
                    )
                } else {
                    continents(summary)
                    countries(summary)
                }
            }
            .padding()
        }
        .navigationTitle(Constants.Strings.yourWorld)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !summary.countries.isEmpty {
                ShareCardButton(title: Constants.Strings.yourWorld, contentID: summary.codes) { () async -> WorldShareCard? in
                    guard let map = await Task.detached(priority: .userInitiated, operation: { WorldMap.bundled }).value else {
                        return nil
                    }
                    return WorldShareCard(map: map, summary: summary)
                }
            }
        }
    }

    private func header(_ summary: VisitedCountriesSummary) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.Strings.countriesCount(summary.countries.count))
                .font(.system(.largeTitle, design: .rounded).bold())
            Text(Constants.Strings.worldSummary(
                continents: summary.visitedContinentCount,
                share: summary.worldShare
            ))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private func continents(_ summary: VisitedCountriesSummary) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Constants.Strings.continents)
                .font(.headline)

            ForEach(summary.continents) { progress in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(Constants.Continents.localizedName(progress.continent))
                        Spacer()
                        Text(Constants.Strings.badgePosition(progress.visited, of: progress.total))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    .font(.subheadline)

                    ProgressView(value: Double(progress.visited), total: Double(max(progress.total, 1)))
                        .tint(progress.visited > 0 ? .green : .secondary)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private func countries(_ summary: VisitedCountriesSummary) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Constants.Strings.visitedCountries)
                .font(.headline)

            ForEach(summary.countries) { country in
                HStack(spacing: 12) {
                    Text(CountryCatalog.flag(for: country.code))
                        .font(.title2)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(CountryCatalog.localizedName(for: country.code))
                            .font(.body)
                        if let firstVisit = country.firstVisit {
                            Text(firstVisit, format: .dateTime.year().month())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Text(Constants.Strings.placesCount(country.placeCount))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VisitedCountriesView()
    }
    .modelContainer(Mock.previewContainer())
}
