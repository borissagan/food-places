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


//  required convenience init(from decoder: Decoder) throws {
//    guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//      throw FPError.missingManagedObjectContext
//    }
//
//    self.init(context: context)
//
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.address = try container.decode(String?.self, forKey: .address)
//    self.name = try container.decode(String?.self, forKey: .name)
//    self.phoneNumber = try container.decode(String?.self, forKey: .phoneNumber)
//    self.longName = try container.decode(String?.self, forKey: .longName)
//    self.url = try container.decode(String?.self, forKey: .url)
//    self.type = try container.decode(String?.self, forKey: .type)
//  }
