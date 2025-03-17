//
//  BackButtonView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 17/03/2025.
//

import SwiftUI

struct BackButtonView: View {
    private let action : () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(
                action: action,
                label: {
                    Image(systemName: Constants.SystemImages.backButton)
                        .foregroundStyle(.green)
                        .font(.caption)
                        .bold()
                        .shadow(radius: 2)
                        .padding(8)
                }
            )
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.green, lineWidth: 3)
            }
            .shadow(radius: 5)
            
            Spacer()
        }
    }
}

#Preview {
    BackButtonView(action: {})
}
