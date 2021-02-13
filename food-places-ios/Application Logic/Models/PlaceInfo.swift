//
//  PlaceInfo.swift
//  food-places-ios
//
//  Created by Boris Sagan on 13.02.2021.
//

import Foundation

struct PlaceInfo: Codable {
  let address: String?
  let name: String?
  let phoneNumber: String?
  let longName: String?
  let url: String?
  let type: String?
  
  enum CodingKeys: String, CodingKey {
    case address = "Place_addr"
    case name = "PlaceName"
    case phoneNumber = "Phone"
    case longName = "LongLabel"
    case url = "URL"
    case type = "Type"
  }
}
