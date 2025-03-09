//
//  BottomPlusButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct BottomPlusButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            HStack {
                Spacer()
                Button(
                    action: {
                        action()
                    },
                    label: {
                        Image(systemName: Constants.SystemImages.plus)
                    }
                )
                .buttonStyle(.borderedProminent)
                .clipShape(Circle())
            }
        }
        .padding()
    }
}

#Preview {
    BottomPlusButton(action: {})
}
