import Foundation
import SwiftData
import UIKit

@Model
final class Trip {
    var id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date?
    var notes: String?
    var image: Data?
    var images: [Data]?

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date = Date(),
        endDate: Date? = nil,
        notes: String? = nil,
        image: Data? = nil,
        images: [Data]? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.image = image
        self.images = images
    }

    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let endDate, !Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            return "\(formatter.string(from: startDate)) – \(formatter.string(from: endDate))"
        }
        return formatter.string(from: startDate)
    }

    var photoData: [Data] {
        if let images, !images.isEmpty { return images }
        if let image { return [image] }
        return []
    }

    var tripImages: [UIImage] {
        photoData.compactMap { UIImage(data: $0) }
    }

    var tripImage: UIImage? {
        tripImages.first
    }
}

extension Trip: Identifiable {}
