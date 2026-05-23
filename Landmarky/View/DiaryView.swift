import SwiftUI

struct DiaryView: View {
    @State private var viewModel = DiaryViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTrip = false

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
                    ForEach(viewModel.trips) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            TripCard(trip: trip)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteTrip(viewModel.trips[index], modelContext: modelContext)
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

#Preview {
    NavigationStack {
        DiaryView()
    }
    .modelContainer(for: [Trip.self])
}
