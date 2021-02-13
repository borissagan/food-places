//
//  Place.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import Foundation

struct Place {
  let lat: Double
  let lon: Double
  let info: PlaceInfo
}

extension Place {
  init(entity: PlaceEntity) {
    self.lat = entity.lat
    self.lon = entity.lon
    self.info = PlaceInfo(
      address: entity.address,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      longName: entity.longName,
      url: entity.url,
      type: entity.type)
  }
}
