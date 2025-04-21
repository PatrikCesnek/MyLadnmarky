//
//  LoadingView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 17/03/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    private let lineWidth: CGFloat
    
    init(lineWidth: CGFloat) {
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        CenterView {
            ZStack {
                Circle()
                    .stroke(Color(.white), lineWidth: lineWidth)
                    .shadow(radius: 10)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(
                        .green,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: self.isLoading
                    )
                    .onAppear() {
                        self.isLoading = true
                    }
            }
            .padding(16)
        }
    }
}

#Preview {
    LoadingView(lineWidth: 20)
}
