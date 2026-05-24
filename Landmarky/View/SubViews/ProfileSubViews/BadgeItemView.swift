import SwiftUI

struct BadgeItemView: View {
    let badge: Badge
    let isEarned: Bool
    let progress: (current: Int, target: Int)
    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail = true
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(isEarned ? badge.tier.color.opacity(0.2) : Color.gray.opacity(0.1))
                        .overlay(
                            Circle()
                                .strokeBorder(isEarned ? badge.tier.color : .gray.opacity(0.3), lineWidth: 2)
                        )
                        .frame(width: 56, height: 56)

                    Image(systemName: badge.icon)
                        .font(.title3)
                        .foregroundStyle(isEarned ? badge.tier.color : .gray.opacity(0.4))
                }

                Text(badge.displayName)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(isEarned ? .primary : .secondary)

                if !isEarned {
                    Text("\(progress.current)/\(progress.target)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 76)
        }
        .buttonStyle(.plain)
        .alert(badge.displayName, isPresented: $showDetail) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(badge.badgeDescription + "\n" + badge.tier.displayName)
        }
    }
}

#Preview {
    HStack {
        BadgeItemView(badge: .firstSteps, isEarned: true, progress: (1, 1))
        BadgeItemView(badge: .explorer, isEarned: false, progress: (2, 5))
        BadgeItemView(badge: .legend, isEarned: false, progress: (3, 100))
    }
}
