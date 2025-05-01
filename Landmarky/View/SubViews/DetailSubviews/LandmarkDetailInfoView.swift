//
//  LandmarkDetailInfoView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 01/05/2025.
//

import SwiftUI

struct LandmarkDetailInfoView: View {
    private let title: String
    private let category: String
    private let description: String?
    
    init(
        title: String,
        category: String,
        description: String?
    ) {
        self.title = title
        self.category = category
        self.description = description
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(category)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                if let description = description {
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    let landmark = Mock.MockLandmarks.data[0]
    LandmarkDetailInfoView(
        title: landmark.name,
        category: landmark.category,
        description: landmark.landmarkDescription
    )
}
