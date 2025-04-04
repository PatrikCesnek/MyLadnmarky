//
//  LandmarkAnnotationImage.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 26/03/2025.
//

import SwiftUI

struct LandmarkAnnotationImage: View {
    private let categoryName: String
    @State private var annotationColor: Color
    
    init(
        categoryName: String,
        annotationColor: Color = .green
    ) {
        self.categoryName = categoryName
        self.annotationColor = annotationColor
    }

    var body: some View {
        Image(
            systemName: HelperFunctions.getCategoryString(categoryName)
        )
        .resizable()
        .foregroundColor(annotationColor)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
        .frame(width: 24, height: 24)
        .padding(6)
        .background {
            Circle()
                .stroke(annotationColor, lineWidth: 4)
                .stroke(.white, lineWidth: 0.5)
        }
        .onAppear{
            annotationColor = HelperFunctions.changeAnnotationColor(categoryName: categoryName)
        }
    }
}

#Preview {
    LandmarkAnnotationImage(categoryName: Constants.Strings.hills)
}

