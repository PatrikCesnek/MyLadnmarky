//
//  LandmarkAnnotationImage.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 26/03/2025.
//

import SwiftUI

struct LandmarkAnnotationImage: View {
    let categoryName: String

    var body: some View {
        // Change color based on category
        Image(
            systemName: HelperFunctions.getCategoryString(
                categoryName: categoryName
            )
        )
        .resizable()
        .foregroundColor(.green)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
        .frame(width: 24, height: 24)
        .padding(6)
        .background {
            Circle()
                .stroke(.green, lineWidth: 4)
                .stroke(.white, lineWidth: 0.5)
        }
    }
}

#Preview {
    LandmarkAnnotationImage(categoryName: Constants.Strings.hills)
}

