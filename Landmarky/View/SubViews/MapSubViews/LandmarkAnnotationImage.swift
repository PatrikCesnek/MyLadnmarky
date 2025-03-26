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
        Image(systemName: HelperFunctions.getCategoryString(categoryName: categoryName))
            .foregroundColor(.green)
            .font(.title)
    }
}

#Preview {
    LandmarkAnnotationImage(categoryName: Constants.Strings.hills)
}

