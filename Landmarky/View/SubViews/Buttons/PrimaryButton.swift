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
    private let isError: Bool
    
    init(
        action: @escaping () -> Void,
        text: String,
        isError: Bool = false
    ) {
        self.action = action
        self.text = text
        self.isError = isError
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
        .tint(isError ? .red : .green)
        .padding(8)
    }
}

#Preview {
    PrimaryButton(action: {}, text: Constants.Buttons.navigate)
}
