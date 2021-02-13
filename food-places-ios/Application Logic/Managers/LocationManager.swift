//
//  LocationManager.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
  private static let defaultLocation = CLLocationCoordinate2D(latitude: 50.450001, longitude: 30.523333) // Kyiv
  private let locationManager: CLLocationManager
  @Published var deviceLocation: CLLocationCoordinate2D?

  override init() {
    self.locationManager = CLLocationManager()
    super.init()
    
    if CLLocationManager.locationServicesEnabled() {
      self.locationManager.delegate = self
      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.requestLocation()
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .restricted || status == .denied {
      deviceLocation = LocationManager.defaultLocation
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("[LocationManager] didFailWithError error: \(error)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard deviceLocation == nil else { return }
    deviceLocation = locations.first?.coordinate
  }
}
