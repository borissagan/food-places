//
//  PlaceFinderManager.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import Foundation
import ArcGIS
import Combine

class PlaceFinderManager {
  private let locatorTask = AGSLocatorTask(url: URLs.arcGISGeocodeServer)
  private var cancelableGeocodeTask: AGSCancelable?
  
  private struct AttributeKeys {
    static let placeAddress = "Place_addr"
    static let placeName = "PlaceName"
    static let all = "*"
  }
  
  enum PlaceType: String {
    case food
  }
  
  func findPlaces(near coordinate: CLLocationCoordinate2D, with type: PlaceType = .food) -> AnyPublisher<[Place], Error> {
    let deffered = Deferred {
      Future<[Place], Error> { [weak self] promise in
        guard let strongSelf = self else {
          promise(Result.failure(FPError.deinited))
          return
        }
        strongSelf.cancelableGeocodeTask?.cancel()
        
        let params = AGSGeocodeParameters()
        params.preferredSearchLocation = AGSPoint(clLocationCoordinate2D: coordinate)
        params.maxResults = 20
        params.resultAttributeNames.append(contentsOf: [AttributeKeys.all])
        
        strongSelf.cancelableGeocodeTask = strongSelf.locatorTask.geocode(
          withSearchText: type.rawValue,
          parameters: params,
          completion: { (results, error) in
            if let error = error {
              print("[PlaceFinderManager] - findPlaces - error: \(error)")
              promise(Result.failure(error))
              return
            }
            
            if let results = results {
              var places = [Place]()
              for result in results {
                guard let lat = result.displayLocation?.toCLLocationCoordinate2D().latitude,
                      let lon = result.displayLocation?.toCLLocationCoordinate2D().longitude,
                      let attributes = result.attributes,
                      let json = try? JSONSerialization.data(withJSONObject: attributes, options: []),
                      let info = try? JSONDecoder().decode(PlaceInfo.self, from: json) else { continue }
                places.append(Place(lat: lat, lon: lon, info: info))
              }
              print("!!! NETWORK REQUEST - [PlaceFinderManager] - findPlaces")
              promise(Result.success(places))
            }
          })
      }
    }.eraseToAnyPublisher()

    return deffered
  }
}
