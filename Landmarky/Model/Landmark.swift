//
//  Landmark.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Landmark {
    var id = UUID()
    var name: String
    var category: String
    var latitude: Double?
    var longitude: Double?
    var image: Data?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        image: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
    }
    
    var landmarkImage: UIImage? {
        guard let imageData = image else { return nil }
        return UIImage(data: imageData)
    }
}

