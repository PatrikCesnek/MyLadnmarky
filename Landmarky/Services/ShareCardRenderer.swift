//
//  ShareCardRenderer.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import CoreTransferable
import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// A rendered share card. Only the pixels drawn on the card are shared: no coordinates,
/// and no photo metadata (EXIF/GPS) survives rendering.
struct ShareCardImage: Transferable, Sendable {
    let jpegData: Data
    let fileName: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .jpeg) { card in
            card.jpegData
        }
        .suggestedFileName { $0.fileName }
    }
}

@MainActor
enum ShareCardRenderer {
    /// Cards are laid out at 360×450 pt and rendered at 3× — 1080×1350 px, the 4:5 portrait
    /// size Instagram and most messengers show without cropping.
    static let cardSize = CGSize(width: 360, height: 450)
    static let scale: CGFloat = 3

    static func render(_ card: some View, fileName: String) -> (image: UIImage, card: ShareCardImage)? {
        let renderer = ImageRenderer(
            content: card
                .frame(width: cardSize.width, height: cardSize.height)
                .environment(\.colorScheme, .dark)
        )
        renderer.scale = scale
        renderer.isOpaque = true

        guard let image = renderer.uiImage, let data = image.jpegData(compressionQuality: 0.9) else {
            return nil
        }
        return (image, ShareCardImage(jpegData: data, fileName: "\(fileName).jpg"))
    }

    /// File-name friendly version of a title, e.g. "Devín Castle!" → "Worldwanderer-Devin-Castle".
    static func fileName(for title: String) -> String {
        let slug = title
            .folding(options: .diacriticInsensitive, locale: nil)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .prefix(6)
            .joined(separator: "-")
        return slug.isEmpty ? "Worldwanderer" : "Worldwanderer-\(slug)"
    }
}
