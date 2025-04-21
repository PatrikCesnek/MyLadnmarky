//
//  TitleSectionView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct TitleSectionView: View {
    @Binding private var title: String
    @Binding private var category: String
    @Binding private var categoryString: String
    private let isCustomCategory: Bool
    
    init(
        title: Binding<String>,
        category: Binding<String>,
        categoryString: Binding<String>,
        isCustomCategory: Bool
    ) {
        self._title = title
        self._category = category
        self._categoryString = categoryString
        self.isCustomCategory = isCustomCategory
    }
    
    var body: some View {
        VStack {
            TextField(
                Constants.Strings.title,
                text: $title
            )
            
            Picker(Constants.Strings.category, selection: $category) {
                ForEach(LandmarkCategory.predefinedCategories, id: \.self) { category in
                    Text(category.localizedName).tag(category.localizedName)
                }
                Text(Constants.Strings.custom).tag(Constants.Strings.custom)
            }
            .pickerStyle(.menu)
            
            if isCustomCategory {
                TextField(Constants.Strings.customCategory, text: $categoryString)
            }
        }
    }
}

#Preview {
    @Previewable @State var title = Mock.MockLandmarks.data[0].name
    @Previewable @State var category = Mock.MockLandmarks.data[0].category
    @Previewable @State var categoryString = Mock.MockLandmarks.data[0].name
    
    TitleSectionView(
        title: $title,
        category: $category,
        categoryString: $categoryString,
        isCustomCategory: false
    )
}
