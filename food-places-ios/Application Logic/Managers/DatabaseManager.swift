//
//  DatabaseManager.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import UIKit
import CoreData
import Combine

class DatabaseManager {
  private let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Places")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
    })
    return container
  }()
  
  let backgroundContext: NSManagedObjectContext
  
  init() {
    backgroundContext = persistentContainer.newBackgroundContext()
  }
  
  func save(_ places: [Place]) {
    backgroundContext.perform {
      self.deleteOldPlaces()
      
      for place in places {
        let entity = PlaceEntity(context: self.backgroundContext)
        entity.lat = place.lat
        entity.lon = place.lon
        entity.address = place.info.address
        entity.name = place.info.name
        entity.longName = place.info.longName
        entity.phoneNumber = place.info.phoneNumber
        entity.url = place.info.url
        entity.type = place.info.type
      }
      
      self.saveToPersistentStorage()
    }
  }
  
  private func deleteOldPlaces() {
    do {
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PlaceEntity.fetchRequest()
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      try self.backgroundContext.execute(batchDeleteRequest)
    } catch {
      print(error)
    }
  }
  
  func fetchPlaces() -> AnyPublisher<[Place], Error> {
    let deferred = Deferred {
      Future<[Place], Error> { [weak self] promise in
        guard let strongSelf = self else {
          promise(Result.failure(FPError.deinited))
          return
        }
        
        strongSelf.backgroundContext.perform {
          let fetchRequest: NSFetchRequest = PlaceEntity.fetchRequest()
          do {
            let entities = try strongSelf.backgroundContext.fetch(fetchRequest)
            promise(Result.success(entities.map { Place(entity: $0) }))
          } catch {
            print("[DatabaseManager] - fetchPlaces - error: \(error)")
            promise(Result.failure(error))
          }
        }
      }
    }.eraseToAnyPublisher()
    
    return deferred
  }
  
  private func saveToPersistentStorage() {
    do {
      try self.backgroundContext.save()
    } catch {
      print(error)
    }
  }
}
