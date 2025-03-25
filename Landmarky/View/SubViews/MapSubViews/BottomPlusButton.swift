//
//  BottomPlusButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import SwiftUI

struct BottomPlusButton<Content: View>: View {
    private let destination: () -> Content
    
    init(@ViewBuilder destination: @escaping () -> Content) {
        self.destination = destination
    }
    
    public var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            HStack(alignment: .bottom) {
                Spacer()
                
                NavigationLink(
                    destination: destination,
                    label: {
                        Image(systemName: Constants.SystemImages.plus)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color.green)
                            }
                    }
                )
            }
        }
    }
}

#Preview {
    BottomPlusButton(destination: { Text("New view") })
}
