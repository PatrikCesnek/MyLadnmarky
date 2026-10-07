//
//  NextBadgeCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct NextBadgeCard: View {
    let item: BadgeItem

    private var fraction: Double {
        guard item.progress.target > 0 else { return 0 }
        return Double(item.progress.current) / Double(item.progress.target)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(item.badge.tier.color.opacity(0.2), lineWidth: 5)
                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(item.badge.tier.color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Image(systemName: item.badge.icon)
                    .font(.title3)
                    .foregroundStyle(item.badge.tier.color)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 2) {
                Text(Constants.Strings.nextBadge)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(item.badge.displayName)
                    .font(.headline)
                Text(item.badge.badgeDescription)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Text(Constants.Strings.badgeRemaining(item.progress.target - item.progress.current))
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(item.badge.tier.color.opacity(0.15), in: Capsule())
                .foregroundStyle(item.badge.tier.color)
        }
        .padding(14)
        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NextBadgeCard(item: BadgeItem(badge: .worldTraveler, isEarned: false, progress: (3, 5)))
}
