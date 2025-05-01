//
//  EmptyView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct EmptyView: View {
    private let title: String
    private let subtitle: String?
    
    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding()
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .padding()
            }
        }
    }
}

#Preview {
    EmptyView(
        title: Constants.Strings.noLandmarks,
        subtitle: Constants.Strings.noAchievements
    )
}
