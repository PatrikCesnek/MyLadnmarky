//
//  YearShareCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// The year at a glance: the summary page of the review and its share card.
struct YearShareCard: View {
    let review: YearInReview
    let map: WorldMap?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(Constants.Strings.yearInReview)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(ShareCardStyle.accent)

            Text(verbatim: String(review.year))
                .font(.system(size: 56, weight: .heavy, design: .rounded))

            if let map, !review.countryCodes.isEmpty {
                WorldMapView(
                    map: map,
                    visitedCodes: Set(review.countryCodes),
                    visitedColor: ShareCardStyle.accent,
                    baseColor: .white.opacity(0.14),
                    minimumVisibleSize: 4
                )
            }

            Spacer(minLength: 0)

            // Plain Grid, not LazyVGrid: lazy containers don't draw in ImageRenderer.
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 10) {
                ForEach(Array(stride(from: 0, to: stats.count, by: 2)), id: \.self) { start in
                    GridRow {
                        ForEach(stats[start..<min(start + 2, stats.count)], id: \.text) { item in
                            stat(item.text, symbol: item.symbol)
                        }
                    }
                }
            }

            ShareCardFooter()
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
        .background(ShareCardStyle.background)
    }

    /// Only what actually happened — a "0 trips" line looks sad on a shared card.
    private var stats: [(text: String, symbol: String)] {
        [
            (review.placeCount, Constants.Strings.placesCount(review.placeCount), "mappin.and.ellipse"),
            (review.countryCodes.count, Constants.Strings.countriesCount(review.countryCodes.count), Constants.SystemImages.globe),
            (review.tripCount, Constants.Strings.tripsCount(review.tripCount), Constants.SystemImages.book),
            (review.badges.count, Constants.Strings.badgesCount(review.badges.count), "medal.fill")
        ]
        .filter { $0.0 > 0 }
        .map { ($0.1, $0.2) }
    }

    private func stat(_ text: String, symbol: String) -> some View {
        Label(text, systemImage: symbol)
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
}
