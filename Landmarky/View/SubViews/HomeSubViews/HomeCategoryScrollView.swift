//
//  HomeCategoryScrollView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct HomeCategoryScrollView: View {
    private let categories: [String]
    private let landmarks: [Landmark]
    
    init(categories: [String], landmarks: [Landmark]) {
        self.categories = categories
        self.landmarks = landmarks
    }
    
    var body: some View {
        ForEach(categories, id: \.self) { category in
            let categoryLandmarks = landmarks(for: category)
            
            if !categoryLandmarks.isEmpty {
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.headline)
                        .padding(.leading, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categoryLandmarks, id: \.id) { landmark in
                                NavigationLink(
                                    destination: {
                                        withAnimation {
                                            LandmarkDetailView(landmark: landmark)
                                        }
                                    },
                                    label: {
                                        LandmarkCard(landmark: landmark)
                                            .padding(.vertical, 8)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    private func landmarks(for category: String) -> [Landmark] {
        if category == Constants.Strings.allLandmarks {
            return landmarks
        }
        return landmarks.filter { $0.category == category }
    }
}

#Preview {
    NavigationStack {
        HomeCategoryScrollView(
            categories: Mock.MockLandmarks.mockCategories,
            landmarks: Mock.MockLandmarks.data
        )
    }
}
