//
//  PhotoImportViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// Finds places in the user's geotagged photos and imports the ones they pick.
/// Nothing is saved until the user confirms; nothing leaves the device.
@MainActor
@Observable
final class PhotoImportViewModel {
    enum Phase: Equatable {
        case intro
        case scanning
        case denied
        case ready
        case importing
        case finished(added: Int)
        case failed(String)
    }

    struct Suggestion: Identifiable {
        let candidate: PhotoPlaceCandidate
        var name: String = ""
        var category: String = Constants.Categories.other
        var isSelected = true
        var place: GeocodedPlace?
        var isResolvingName = true
        /// Name we suggested; if `name` differs, the user typed their own and we keep it.
        fileprivate var suggestedName = ""

        var id: String { candidate.id }
    }

    private(set) var phase: Phase = .intro
    private(set) var access: PhotoLibraryAccess
    var suggestions: [Suggestion] = []

    let library: any PhotoLibraryProviding
    private let geocode: CountryBackfillService.Geocoder

    var selectedCount: Int {
        suggestions.filter(\.isSelected).count
    }

    init(
        library: any PhotoLibraryProviding = PhotoLibraryService(),
        geocode: @escaping CountryBackfillService.Geocoder = GeocodingHelper.reverseGeocode
    ) {
        self.library = library
        self.geocode = geocode
        self.access = library.currentAccess()
    }

    func scan(using context: ModelContext) async {
        guard phase != .scanning, phase != .importing else { return }

        if access == .notDetermined {
            access = await library.requestAccess()
        }
        guard access == .full || access == .limited else {
            phase = .denied
            return
        }

        phase = .scanning
        let existing = ((try? context.fetch(FetchDescriptor<Landmark>())) ?? [])
            .compactMap { landmark -> (latitude: Double, longitude: Double)? in
                guard let latitude = landmark.latitude, let longitude = landmark.longitude else { return nil }
                return (latitude, longitude)
            }

        let points = await library.geotaggedPhotos()
        let picked = await Task.detached(priority: .userInitiated) {
            PhotoPlaceClusterer.suggestions(
                from: PhotoPlaceClusterer.cluster(points),
                existingCoordinates: existing
            )
        }.value

        suggestions = picked.map { Suggestion(candidate: $0) }
        phase = .ready
        await resolveNames()
    }

    func setAllSelected(_ isSelected: Bool) {
        for index in suggestions.indices {
            suggestions[index].isSelected = isSelected
        }
    }

    /// Saves the selected suggestions as visited places in one transaction.
    func importSelected(using context: ModelContext) async {
        guard phase == .ready else { return }
        let selected = suggestions.filter(\.isSelected)
        guard !selected.isEmpty else { return }
        phase = .importing

        var newLandmarks: [Landmark] = []
        for suggestion in selected {
            let candidate = suggestion.candidate
            let trimmedName = suggestion.name.trimmingCharacters(in: .whitespacesAndNewlines)
            let landmark = Landmark(
                name: trimmedName.isEmpty ? Constants.Strings.unknownPlace : trimmedName,
                category: suggestion.category,
                latitude: candidate.latitude,
                longitude: candidate.longitude,
                image: await library.importableJPEG(for: candidate.representativePhotoID),
                visitDate: candidate.firstDate ?? candidate.lastDate,
                country: suggestion.place?.country,
                continent: suggestion.place?.continent,
                countryCode: suggestion.place?.countryCode
            )
            newLandmarks.append(landmark)
        }

        newLandmarks.forEach(context.insert)
        do {
            try context.save()
            phase = .finished(added: newLandmarks.count)
        } catch {
            newLandmarks.forEach(context.delete)
            phase = .failed(error.localizedDescription)
        }
    }

    /// Names suggestions one at a time — Apple rate-limits reverse geocoding.
    private func resolveNames() async {
        for id in suggestions.map(\.id) {
            guard !Task.isCancelled, phase == .ready,
                  let candidate = suggestions.first(where: { $0.id == id })?.candidate else { return }

            let place = await geocode(candidate.latitude, candidate.longitude)

            guard let index = suggestions.firstIndex(where: { $0.id == id }) else { continue }
            suggestions[index].place = place
            suggestions[index].isResolvingName = false
            if let category = place?.category, suggestions[index].category == Constants.Categories.other {
                suggestions[index].category = category.localizedName
            }
            if suggestions[index].name == suggestions[index].suggestedName {
                let name = place?.name ?? Constants.Strings.unknownPlace
                suggestions[index].name = name
                suggestions[index].suggestedName = name
            }
        }
    }
}
