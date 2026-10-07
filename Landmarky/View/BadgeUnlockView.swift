//
//  BadgeUnlockView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct BadgeUnlockView<Accessory: View>: View {
    let badge: Badge
    let position: (index: Int, total: Int)
    let onContinue: () -> Void
    @ViewBuilder let accessory: () -> Accessory

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isRevealed = false
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Color.black.opacity(0.35))
                .ignoresSafeArea()

            if !reduceMotion {
                ConfettiView(colors: [badge.tier.color, .green, .yellow, .white])
                    .ignoresSafeArea()
                    .id(badge)
            }

            VStack(spacing: 20) {
                Text(Constants.Strings.badgeUnlocked)
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundStyle(badge.tier.color)

                medal

                VStack(spacing: 8) {
                    Text(badge.displayName)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(badge.badgeDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text(badge.tier.displayName)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(badge.tier.color.opacity(0.2), in: Capsule())
                        .foregroundStyle(badge.tier.color)
                }

                if position.total > 1 {
                    Text(Constants.Strings.badgePosition(position.index, of: position.total))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    accessory()

                    Button(action: onContinue) {
                        Text(Constants.Buttons.continueButton)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .prominentButtonStyle()
                    .tint(.green)
                }
                .padding(.top, 8)
            }
            .padding(28)
            .frame(maxWidth: 420)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 32))
            .padding(24)
            .scaleEffect(isRevealed || reduceMotion ? 1 : 0.6)
            .opacity(isRevealed || reduceMotion ? 1 : 0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .sensoryFeedback(.success, trigger: badge)
        .onAppear(perform: reveal)
        .onChange(of: badge) { _, _ in
            isRevealed = false
            reveal()
        }
    }

    private var medal: some View {
        ZStack {
            Circle()
                .stroke(badge.tier.color.opacity(0.35), lineWidth: 2)
                .frame(width: 170, height: 170)
                .scaleEffect(isPulsing ? 1.12 : 0.95)
                .opacity(isPulsing ? 0 : 1)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [badge.tier.color.opacity(0.95), badge.tier.color.opacity(0.55)],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 160
                    )
                )
                .overlay(Circle().strokeBorder(.white.opacity(0.6), lineWidth: 3))
                .frame(width: 140, height: 140)
                .shadow(color: badge.tier.color.opacity(0.6), radius: 24)

            Image(systemName: badge.icon)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, value: isRevealed)
        }
        .accessibilityHidden(true)
    }

    private func reveal() {
        AccessibilityNotification.Announcement(
            "\(Constants.Strings.badgeUnlocked) \(badge.displayName)"
        ).post()

        guard !reduceMotion else {
            isRevealed = true
            return
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            isRevealed = true
        }
        isPulsing = false
        withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
            isPulsing = true
        }
    }
}

extension BadgeUnlockView where Accessory == SwiftUI.EmptyView {
    init(badge: Badge, position: (index: Int, total: Int), onContinue: @escaping () -> Void) {
        self.init(badge: badge, position: position, onContinue: onContinue) { SwiftUI.EmptyView() }
    }
}

#Preview {
    BadgeUnlockView(badge: .jetSetter, position: (1, 3), onContinue: {})
}
