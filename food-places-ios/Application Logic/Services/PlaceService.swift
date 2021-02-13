//
//  PlaceService.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import UIKit
import CoreLocation
import Combine

class PlaceService {
  private let finder: PlaceFinderManager
  private let database: DatabaseManager
  private let locator: LocationManager
  private var cancellables = Set<AnyCancellable>()
  
  @Published var places: [Place] = []
  @Published var deviceLocation: CLLocationCoordinate2D?
  
  init(database: DatabaseManager, finder: PlaceFinderManager, locator: LocationManager) {
    self.database = database
    self.finder = finder
    self.locator = locator
    
    self.bindData()
    self.fetchPlaces()
  }
  
  private func bindData() {
    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] (notification) in
        guard let strongSelf = self else { return }
        strongSelf.database.save(strongSelf.places)
      }
      .store(in: &cancellables)
    
    locator.$deviceLocation
      .sink { [weak self] (coordinate) in
        guard let strongSelf = self, let coordinate = coordinate, strongSelf.places.count == 0 else { return }
        strongSelf.deviceLocation = coordinate
    }
    .store(in: &cancellables)
  }
  
  func findPlaces(near coordinate: CLLocationCoordinate2D) {
    finder.findPlaces(near: coordinate)
      .replaceError(with: [])
      .assign(to: \.places, on: self)
      .store(in: &cancellables)
  }
  
  private func fetchPlaces() {
    database.fetchPlaces()
      .sink(receiveCompletion: { (completion) in
        print("[PlaceService] - fetchPlaces - completion: \(completion)")
      }, receiveValue: { (places) in
        if places.count > 0 { self.places = places }
      })
      .store(in: &cancellables)
  }
}
