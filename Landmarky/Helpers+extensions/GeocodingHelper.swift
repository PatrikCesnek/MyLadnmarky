import CoreLocation
import MapKit

struct GeocodingHelper {
    static func reverseGeocode(latitude: Double, longitude: Double) async -> (country: String, continent: String)? {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        guard let request = MKReverseGeocodingRequest(location: location),
              let mapItems = try? await request.mapItems,
              let addressRepresentations = mapItems.first?.addressRepresentations,
              let country = addressRepresentations.regionName,
              let countryCode = addressRepresentations.region?.identifier else {
            return nil
        }

        let continent = ContinentMapper.continent(forCountryCode: countryCode)
        return (country, continent)
    }
}
