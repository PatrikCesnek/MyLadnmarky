//
//  ProfileCellView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftUI

struct ProfileCellView: View {
    private let text: String?
    private let showDivider: Bool
    
    init(
        text: String?,
        showDivider: Bool = true
    ) {
        self.text = text
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text ?? Constants.Strings.enterName)
            if showDivider {
                Divider()
            }
        }
    }
}

#Preview {
    ProfileCellView(text: "John", showDivider: true)
}
