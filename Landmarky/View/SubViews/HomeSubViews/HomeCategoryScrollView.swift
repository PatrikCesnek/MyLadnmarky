//
//  HomeCategoryScrollView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct HomeCategoryScrollView: View {
    private let categories: [LandmarkCategory]
    private let landmarks: [Landmark]
    
    init(categories: [LandmarkCategory], landmarks: [Landmark]) {
        self.categories = categories
        self.landmarks = landmarks
    }
    
    var body: some View {
        ForEach(categories, id: \.self) { category in
            let categoryLandmarks = landmarks(for: category)
            
            if !categoryLandmarks.isEmpty {
                VStack(alignment: .leading) {
                    Text(category.localizedName)
                        .font(.headline)
                        .padding(.leading, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categoryLandmarks, id: \.id) { landmark in
                                NavigationLink(
                                    destination: LandmarkDetailView(landmark: landmark),
                                    label: {
                                        LandmarkCard(landmark: landmark)
                                            .padding(.vertical, 8)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    func landmarks(for category: LandmarkCategory) -> [Landmark] {
        if category == .all {
            return landmarks
        }
        return landmarks.filter { $0.category == category.localizedName }
    }
}

#Preview {
    HomeCategoryScrollView(
        categories: [.all, .bars, .castles],
        landmarks: Mock.MockLandmarks.data
    )
}
