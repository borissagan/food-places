//
//  ItemIdentifier.swift
//  food-places-ios
//
//  Created by Boris Sagan on 13.02.2021.
//

import Foundation

class ItemIdentifier<T> {
  let ID = UUID()
  let value: T
  
  init(value: T) {
    self.value = value
  }
}

extension ItemIdentifier: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(ID)
  }
}

extension ItemIdentifier: Equatable {
  static func == (lhs: ItemIdentifier, rhs: ItemIdentifier) -> Bool {
    lhs.ID == rhs.ID
  }
}
