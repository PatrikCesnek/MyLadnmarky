import SwiftData
import SwiftUI

@Observable
class DiaryViewModel {
    var trips: [Trip] = []
    var error: String?

    @MainActor
    func fetchTrips(modelContext: ModelContext) {
        error = nil

        if Constants.showsMockData {
            trips = Mock.MockTrips.data.sorted { $0.startDate > $1.startDate }
            return
        }

        let descriptor = FetchDescriptor<Trip>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        do {
            trips = try modelContext.fetch(descriptor)
        } catch {
            self.error = error.localizedDescription
        }
    }

    @MainActor
    func deleteTrip(_ trip: Trip, modelContext: ModelContext) {
        if Constants.showsMockData {
            trips.removeAll { $0.id == trip.id }
            return
        }

        modelContext.delete(trip)
        do {
            try modelContext.save()
            fetchTrips(modelContext: modelContext)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
