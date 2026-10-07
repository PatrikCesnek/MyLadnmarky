//
//  WorldShareCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct WorldShareCard: View {
    let map: WorldMap
    let summary: VisitedCountriesSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(Constants.Strings.yourWorld)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(ShareCardStyle.accent)

            Text(Constants.Strings.countriesCount(summary.countries.count))
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(Constants.Strings.worldSummary(
                continents: summary.visitedContinentCount,
                share: summary.worldShare
            ))
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white.opacity(0.75))

            Spacer(minLength: 0)

            WorldMapView(
                map: map,
                visitedCodes: summary.codes,
                visitedColor: ShareCardStyle.accent,
                baseColor: .white.opacity(0.14),
                minimumVisibleSize: 4
            )

            Spacer(minLength: 0)

            Text(summary.countries.prefix(24).map { CountryCatalog.flag(for: $0.code) }.joined(separator: " "))
                .font(.system(size: 18))
                .lineLimit(2)

            ShareCardFooter()
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
        .background(ShareCardStyle.background)
    }
}
