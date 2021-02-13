//
//  ServiceProvider.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import Foundation

class ServiceProvider {
  static let shared = ServiceProvider()
  
  private let database: DatabaseManager
  private let finder: PlaceFinderManager
  private let locator: LocationManager
  
  let places: PlaceService
  
  private init() {
    self.database = DatabaseManager()
    self.finder = PlaceFinderManager()
    self.locator = LocationManager()
    self.places = PlaceService(database: database, finder: finder, locator: locator)
  }
}
