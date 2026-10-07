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
    /// Our category for the point of interest, when Maps knows what kind of place it is.
    var category: LandmarkCategory? = nil
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
            continent: ContinentMapper.continent(forCountryCode: countryCode),
            category: mapItem.pointOfInterestCategory.flatMap(LandmarkCategory.init(pointOfInterest:))
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

extension LandmarkCategory {
    /// Maps Apple Maps' point-of-interest kinds onto our categories; nil when nothing fits.
    init?(pointOfInterest category: MKPointOfInterestCategory) {
        if #available(iOS 18.0, *) {
            switch category {
            case .castle, .fortress: self = .castles; return
            case .landmark, .nationalMonument: self = .historicalLandmarks; return
            case .hiking, .rockClimbing: self = .hills; return
            default: break
            }
        }

        switch category {
        case .park, .nationalPark, .campground: self = .parks
        case .beach, .marina: self = .lakes
        case .museum: self = .historicalLandmarks
        case .restaurant, .bakery, .cafe, .foodMarket: self = .restaurants
        case .nightlife, .brewery, .winery: self = .bars
        case .store: self = .shops
        case .amusementPark, .aquarium, .zoo, .theater, .movieTheater, .stadium: self = .entertainment
        default: return nil
        }
    }
}
