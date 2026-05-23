import SwiftUI

struct BadgeGridView: View {
    let items: [BadgeItem]

    private let columns = [
        GridItem(.adaptive(minimum: 76), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items) { item in
                BadgeItemView(
                    badge: item.badge,
                    isEarned: item.isEarned,
                    progress: item.progress
                )
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let stats = BadgeStats(landmarks: [], tripCount: 0)
    BadgeGridView(items: Badge.evaluateAll(stats: stats))
}
