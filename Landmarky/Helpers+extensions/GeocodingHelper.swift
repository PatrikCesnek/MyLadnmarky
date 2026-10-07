import CoreLocation
import MapKit

struct GeocodedPlace: Equatable, Sendable {
    /// Best human-readable name for the spot (point of interest, else locality).
    let name: String?
    /// Localized country name, as shown to the user.
    let country: String
    /// ISO 3166-1 alpha-2 code, stable across languages.
    let countryCode: String
    let continent: String
}

struct GeocodingHelper {
    static func reverseGeocode(latitude: Double, longitude: Double) async -> GeocodedPlace? {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        if #available(iOS 26.0, *) {
            return await reverseGeocodeWithMapKit(location)
        } else {
            return await reverseGeocodeWithCoreLocation(location)
        }
    }

    @available(iOS 26.0, *)
    private static func reverseGeocodeWithMapKit(_ location: CLLocation) async -> GeocodedPlace? {
        guard let request = MKReverseGeocodingRequest(location: location),
              let mapItem = try? await request.mapItems.first,
              let addressRepresentations = mapItem.addressRepresentations,
              let country = addressRepresentations.regionName,
              let countryCode = addressRepresentations.region?.identifier else {
            return nil
        }

        return GeocodedPlace(
            name: mapItem.name ?? addressRepresentations.cityName,
            country: country,
            countryCode: countryCode.uppercased(),
            continent: ContinentMapper.continent(forCountryCode: countryCode)
        )
    }

    private static func reverseGeocodeWithCoreLocation(_ location: CLLocation) async -> GeocodedPlace? {
        guard let placemark = try? await CLGeocoder().reverseGeocodeLocation(location).first,
              let country = placemark.country,
              let countryCode = placemark.isoCountryCode else {
            return nil
        }

        return GeocodedPlace(
            name: placemark.areasOfInterest?.first ?? placemark.name ?? placemark.locality,
            country: country,
            countryCode: countryCode.uppercased(),
            continent: ContinentMapper.continent(forCountryCode: countryCode)
        )
    }
}
