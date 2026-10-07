//
//  PhotoLibraryService.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Photos
import Synchronization
import UIKit

enum PhotoLibraryAccess: Sendable, Equatable {
    case notDetermined
    case full
    case limited
    case denied
}

/// The photo library seen through the import feature. A protocol so the import flow can be
/// tested without PhotoKit.
protocol PhotoLibraryProviding: Sendable {
    func currentAccess() -> PhotoLibraryAccess
    func requestAccess() async -> PhotoLibraryAccess
    /// Location and date of every photo the app can see that has a location.
    func geotaggedPhotos() async -> [PhotoPoint]
    func thumbnail(for photoID: String, pixelSide: CGFloat) async -> UIImage?
    /// JPEG suitable for storing on a landmark. Re-encoded, so it carries no EXIF/GPS.
    func importableJPEG(for photoID: String) async -> Data?
}

/// PhotoKit-backed implementation. Everything stays on device; iCloud originals are
/// downloaded only through the system when the user's library is in iCloud.
struct PhotoLibraryService: PhotoLibraryProviding {
    static let importMaxDimension: CGFloat = 1600

    func currentAccess() -> PhotoLibraryAccess {
        Self.map(PHPhotoLibrary.authorizationStatus(for: .readWrite))
    }

    func requestAccess() async -> PhotoLibraryAccess {
        Self.map(await PHPhotoLibrary.requestAuthorization(for: .readWrite))
    }

    func geotaggedPhotos() async -> [PhotoPoint] {
        await Task.detached(priority: .userInitiated) {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            options.includeHiddenAssets = false
            let assets = PHAsset.fetchAssets(with: .image, options: options)

            var points: [PhotoPoint] = []
            points.reserveCapacity(assets.count / 2)
            assets.enumerateObjects { asset, _, _ in
                guard let coordinate = asset.location?.coordinate else { return }
                points.append(PhotoPoint(
                    id: asset.localIdentifier,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    date: asset.creationDate
                ))
            }
            return points
        }.value
    }

    func thumbnail(for photoID: String, pixelSide: CGFloat) async -> UIImage? {
        await image(for: photoID, targetSize: CGSize(width: pixelSide, height: pixelSide), contentMode: .aspectFill)
    }

    func importableJPEG(for photoID: String) async -> Data? {
        let size = CGSize(width: Self.importMaxDimension, height: Self.importMaxDimension)
        guard let image = await image(for: photoID, targetSize: size, contentMode: .aspectFit) else { return nil }
        return image.jpegData(compressionQuality: 0.8)
    }

    private func image(for photoID: String, targetSize: CGSize, contentMode: PHImageContentMode) async -> UIImage? {
        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [photoID], options: nil).firstObject else {
            return nil
        }

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false

        return await withCheckedContinuation { continuation in
            let gate = ResumeOnce()
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options
            ) { image, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard !isDegraded || image == nil else { return }
                if gate.claim() {
                    continuation.resume(returning: image)
                }
            }
        }
    }

    private static func map(_ status: PHAuthorizationStatus) -> PhotoLibraryAccess {
        switch status {
        case .authorized: .full
        case .limited: .limited
        case .notDetermined: .notDetermined
        case .denied, .restricted: .denied
        @unknown default: .denied
        }
    }
}

/// Guards a continuation against PhotoKit calling its handler more than once.
private final class ResumeOnce: Sendable {
    private let claimed = Mutex(false)

    func claim() -> Bool {
        claimed.withLock { claimed in
            guard !claimed else { return false }
            claimed = true
            return true
        }
    }
}
