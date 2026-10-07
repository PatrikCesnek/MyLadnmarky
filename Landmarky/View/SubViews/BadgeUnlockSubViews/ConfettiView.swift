//
//  ConfettiView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Lightweight one-shot confetti burst drawn with Canvas — no assets, no dependencies.
struct ConfettiView: View {
    let colors: [Color]
    var pieceCount = 90
    var duration: Double = 3.2

    @State private var startDate = Date()
    @State private var pieces: [ConfettiPiece] = []

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                guard elapsed < duration else { return }

                for piece in pieces {
                    let progress = elapsed / duration
                    let x = size.width * piece.startX + piece.drift * size.width * progress
                    let y = -20 + (size.height + 40) * piece.fallSpeed * progress
                        + sin(elapsed * piece.wobbleSpeed) * 12
                    let opacity = max(0, 1 - pow(progress, 3))

                    var pieceContext = context
                    pieceContext.opacity = opacity
                    pieceContext.translateBy(x: x, y: y)
                    pieceContext.rotate(by: .degrees(piece.spin * elapsed))
                    let rect = CGRect(x: -piece.width / 2, y: -piece.height / 2, width: piece.width, height: piece.height)
                    pieceContext.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(colors[piece.colorIndex % colors.count]))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            startDate = Date()
            pieces = (0..<pieceCount).map { _ in ConfettiPiece.random(colorCount: colors.count) }
        }
    }
}

private struct ConfettiPiece {
    let startX: Double
    let drift: Double
    let fallSpeed: Double
    let wobbleSpeed: Double
    let spin: Double
    let width: Double
    let height: Double
    let colorIndex: Int

    static func random(colorCount: Int) -> ConfettiPiece {
        ConfettiPiece(
            startX: .random(in: 0...1),
            drift: .random(in: -0.15...0.15),
            fallSpeed: .random(in: 0.7...1.3),
            wobbleSpeed: .random(in: 2...6),
            spin: .random(in: -360...360),
            width: .random(in: 6...10),
            height: .random(in: 10...16),
            colorIndex: .random(in: 0..<max(colorCount, 1))
        )
    }
}

#Preview {
    ConfettiView(colors: [.green, .yellow, .purple, .cyan])
}
