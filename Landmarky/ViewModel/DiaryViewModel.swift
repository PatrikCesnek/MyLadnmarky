import SwiftData
import SwiftUI

@Observable
class DiaryViewModel {
    var trips: [Trip] = []
    var error: String?

    @MainActor
    func fetchTrips(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Trip>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        error = nil
        do {
            trips = try modelContext.fetch(descriptor)
        } catch {
            self.error = error.localizedDescription
        }
    }

    @MainActor
    func deleteTrip(_ trip: Trip, modelContext: ModelContext) {
        modelContext.delete(trip)
        do {
            try modelContext.save()
            fetchTrips(modelContext: modelContext)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
