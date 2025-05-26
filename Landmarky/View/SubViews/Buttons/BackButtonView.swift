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
        Button(
            action: {
                withAnimation {
                    action()
                }
            },
            label: {
                Image(systemName: Constants.SystemImages.backButton)
                    .resizable()
                    .foregroundStyle(.green)
                    .shadow(radius: 2)
                    .frame(width: 20, height: 40)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.green, lineWidth: 4)
                            .frame(width: 50, height: 50)
                    }
                    .shadow(radius: 5)
            }
        )
        .frame(width: 50, height: 50)
    }
}

#Preview {
    BackButtonView(action: {})
}
