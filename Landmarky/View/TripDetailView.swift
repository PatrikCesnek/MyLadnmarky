import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @State private var isEditing = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label(trip.dateRangeText, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let notes = trip.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.body)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(trip.title)
        .toolbar {
            Button {
                isEditing = true
            } label: {
                Image(systemName: Constants.SystemImages.editButtonImage)
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            .buttonStyle(.borderless)
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                AddTripView(trip: trip)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TripDetailView(trip: Trip(title: "Weekend in Vienna", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()), notes: "Had a wonderful time exploring the city. Visited Schönbrunn Palace and tried amazing Sachertorte."))
    }
}
