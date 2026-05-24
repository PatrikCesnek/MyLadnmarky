import SwiftUI

struct ProfileStatsView: View {
    let landmarkCount: Int
    let countriesCount: Int
    let badgesEarned: Int
    let totalBadges: Int

    var body: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(landmarkCount)", label: Constants.Strings.statsLandmarks)
            Divider().frame(height: 40)
            StatItem(value: "\(countriesCount)", label: Constants.Strings.statsCountries)
            Divider().frame(height: 40)
            StatItem(value: "\(badgesEarned)/\(totalBadges)", label: Constants.Strings.statsBadges)
        }
    }
}

private struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileStatsView(landmarkCount: 12, countriesCount: 3, badgesEarned: 5, totalBadges: 28)
}
