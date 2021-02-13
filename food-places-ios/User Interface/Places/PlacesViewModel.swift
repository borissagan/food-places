//
//  PlacesViewModel.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import Foundation
import Combine
import CoreLocation

class PlacesViewModel {
  @Published var deviceLocation: CLLocationCoordinate2D?
  @Published var coordinate: CLLocationCoordinate2D?
  @Published var places: [Place] = []
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    ServiceProvider.shared.places.$places
      .assign(to: \.places, on: self)
      .store(in: &cancellables)
    
    $coordinate
      .debounce(for: 0.3, scheduler: DispatchQueue.global())
      .sink { (coordinate) in
        guard let coordinate = coordinate else { return }
        ServiceProvider.shared.places.findPlaces(near: coordinate)
      }
      .store(in: &cancellables)
    
    ServiceProvider.shared.places.$deviceLocation
      .sink { (coordinate) in
        guard let coordinate = coordinate, self.places.count == 0 else { return }
        self.deviceLocation = coordinate
      }
      .store(in: &cancellables)
  }
}
