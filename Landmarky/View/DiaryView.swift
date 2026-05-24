import SwiftUI

struct DiaryView: View {
    @State private var viewModel = DiaryViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTrip = false
    @State private var selectedPhoto: SelectedTripPhoto?

    private var tripSections: [TripDaySection] {
        let groupedTrips = Dictionary(grouping: viewModel.trips) { trip in
            Calendar.current.startOfDay(for: trip.startDate)
        }

        return groupedTrips
            .map { date, trips in
                TripDaySection(
                    date: date,
                    trips: trips.sorted { $0.startDate > $1.startDate }
                )
            }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        Group {
            if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retryAction: {
                        viewModel.fetchTrips(modelContext: modelContext)
                    }
                )
                .padding(.horizontal, 16)
            } else if viewModel.trips.isEmpty {
                EmptyView(
                    title: Constants.Strings.noTrips,
                    subtitle: Constants.Strings.startDocumenting
                )
            } else {
                List {
                    ForEach(tripSections) { section in
                        Section(section.title) {
                            ForEach(section.trips) { trip in
                                VStack(alignment: .leading, spacing: 8) {
                                    NavigationLink {
                                        TripDetailView(trip: trip)
                                    } label: {
                                        TripCard(trip: trip, showsImage: false)
                                    }

                                    if !trip.tripImages.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
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
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.deleteTrip(section.trips[index], modelContext: modelContext)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Constants.Strings.travelDiary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                showAddTrip = true
            } label: {
                Image(systemName: Constants.SystemImages.plus)
                    .font(.headline)
            }
            .buttonStyle(.glassProminent)
            .tint(.green)
        }
        .sheet(isPresented: $showAddTrip) {
            NavigationStack {
                AddTripView()
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            TripPhotoDetailView(image: photo.image)
        }
        .onAppear {
            viewModel.fetchTrips(modelContext: modelContext)
        }
        .onChange(of: showAddTrip) { _, isPresented in
            if !isPresented {
                viewModel.fetchTrips(modelContext: modelContext)
            }
        }
    }
}

private struct TripDaySection: Identifiable {
    let date: Date
    let trips: [Trip]

    var id: Date { date }

    var title: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

private struct SelectedTripPhoto: Identifiable {
    let id = UUID()
    let image: UIImage
}

#Preview {
    NavigationStack {
        DiaryView()
    }
    .modelContainer(for: [Trip.self])
}
