//
//  GenericError.swift
//  food-places-ios
//
//  Created by Boris Sagan on 12.02.2021.
//

import Foundation

enum FPError: Error {
  case somethingWentWrong
  case missingManagedObjectContext
  case invalidJSON
  case deinited
}
