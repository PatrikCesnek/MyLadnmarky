import CoreLocation

struct GeocodingHelper {
    private static let geocoder = CLGeocoder()

    static func reverseGeocode(latitude: Double, longitude: Double) async -> (country: String, continent: String)? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let placemarks = try? await geocoder.reverseGeocodeLocation(location),
              let placemark = placemarks.first,
              let country = placemark.country,
              let countryCode = placemark.isoCountryCode else {
            return nil
        }
        let continent = ContinentMapper.continent(forCountryCode: countryCode)
        return (country, continent)
    }
}
