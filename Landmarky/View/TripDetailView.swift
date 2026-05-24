import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @State private var isEditing = false
    @State private var selectedPhoto: SelectedTripPhoto?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label(trip.dateRangeText, systemImage: Constants.SystemImages.calendar)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if !trip.tripImages.isEmpty {
                    LazyVGrid(columns: galleryColumns, alignment: .leading, spacing: 8) {
                        ForEach(Array(trip.tripImages.enumerated()), id: \.offset) { _, image in
                            Button {
                                selectedPhoto = SelectedTripPhoto(image: image)
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

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
        .sheet(item: $selectedPhoto) { photo in
            TripPhotoDetailView(image: photo.image)
        }
    }

    private var galleryColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 80), spacing: 8)]
    }
}

private struct SelectedTripPhoto: Identifiable {
    let id = UUID()
    let image: UIImage
}

#Preview {
    NavigationStack {
        TripDetailView(trip: Trip(title: "Weekend in Vienna", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()), notes: "Had a wonderful time exploring the city. Visited Schönbrunn Palace and tried amazing Sachertorte."))
    }
}
