//
//  BadgeShareCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct BadgeShareCard: View {
    let badge: Badge

    var body: some View {
        ZStack {
            ShareCardStyle.background

            RadialGradient(
                colors: [badge.tier.color.opacity(0.55), .clear],
                center: .init(x: 0.5, y: 0.38),
                startRadius: 10,
                endRadius: 260
            )

            VStack(spacing: 18) {
                Text(Constants.Strings.badgeUnlocked)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(badge.tier.color)

                ZStack {
                    Circle()
                        .stroke(badge.tier.color.opacity(0.4), lineWidth: 2)
                        .frame(width: 170, height: 170)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [badge.tier.color, badge.tier.color.opacity(0.55)],
                                center: .topLeading,
                                startRadius: 10,
                                endRadius: 160
                            )
                        )
                        .overlay(Circle().strokeBorder(.white.opacity(0.7), lineWidth: 3))
                        .frame(width: 140, height: 140)
                    Image(systemName: badge.icon)
                        .font(.system(size: 58, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 6) {
                    Text(badge.displayName)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text(badge.badgeDescription)
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                    Text(badge.tier.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(badge.tier.color.opacity(0.25), in: Capsule())
                        .foregroundStyle(badge.tier.color)
                        .padding(.top, 4)
                }
                .foregroundStyle(.white)

                Spacer(minLength: 0)

                ShareCardFooter()
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)
            .padding(.bottom, 22)
        }
        .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
    }
}

#Preview {
    BadgeShareCard(badge: .jetSetter)
}
