import SwiftUI

struct TripCard: View {
    let trip: Trip
    var showsImage = true

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if showsImage,
               let image = trip.tripImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(.headline)
                Text(trip.dateRangeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let notes = trip.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TripCard(trip: Trip(title: "Weekend in Vienna", startDate: Date(), notes: "Had a wonderful time"))
}
