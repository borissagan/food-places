//
//  SectionIdentifier.swift
//  food-places-ios
//
//  Created by Boris Sagan on 13.02.2021.
//

import Foundation

class SectionIdentifier {
  let ID = UUID()
  let title: String
  
  init(title: String = "") {
    self.title = title
  }
}

extension SectionIdentifier: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(ID)
  }
}

extension SectionIdentifier: Equatable {
  static func == (lhs: SectionIdentifier, rhs: SectionIdentifier) -> Bool {
    lhs.ID == rhs.ID
  }
}
