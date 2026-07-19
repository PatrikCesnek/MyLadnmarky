//
//  BottomPlusButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct BottomPlusButton<Content: View>: View {
    private let destination: () -> Content

    @State private var isPresented = false
    @State private var sessionID = UUID()

    init(@ViewBuilder destination: @escaping () -> Content) {
        self.destination = destination
    }

    public var body: some View {
        VStack(alignment: .trailing) {
            Spacer()

            HStack(alignment: .bottom) {
                Spacer()

                Button(
                    action: {
                        sessionID = UUID()
                        isPresented = true
                    },
                    label: {
                        Image(systemName: Constants.SystemImages.plus)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .padding(8)
                    }
                )
                .tint(.green)
                .buttonStyle(.glassProminent)
                .clipShape(Circle())
            }
        }
        .navigationDestination(isPresented: $isPresented) {
            destination()
                .id(sessionID)
        }
    }
}

#Preview {
    BottomPlusButton(destination: { Text("New view") })
}
