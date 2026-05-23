import Foundation
import SwiftData

@Model
final class Trip {
    var id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date?
    var notes: String?

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date = Date(),
        endDate: Date? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
    }

    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let endDate, !Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            return "\(formatter.string(from: startDate)) – \(formatter.string(from: endDate))"
        }
        return formatter.string(from: startDate)
    }
}

extension Trip: Identifiable {}
