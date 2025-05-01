//
//  PrimaryButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import SwiftUI

struct PrimaryButton: View {
    private let action: () -> Void
    private let text: String
    
    init(
        action: @escaping () -> Void,
        text: String
    ) {
        self.action = action
        self.text = text
    }
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(text)
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
            }
        )
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .tint(.green)
        .padding(8)
    }
}

#Preview {
    PrimaryButton(action: {}, text: Constants.Buttons.navigate)
}
