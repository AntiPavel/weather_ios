//
//  CoreData.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import CoreData

final class CoreData: StorageService {
    
    static let shared = CoreData()
    
    lazy var cityPersistentContainer: NSPersistentContainer = {
        let container = getContainer("City")
        return container
    }()
    
    public var cityViewContext: NSManagedObjectContext? {
        return cityPersistentContainer.viewContext
    }
    
    public var cityUpdateContext: NSManagedObjectContext {
        privateCityUpdateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return privateCityUpdateContext
    }
    
    private func getContainer(_ name: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
    
    private lazy var privateCityUpdateContext: NSManagedObjectContext = cityPersistentContainer.newBackgroundContext()
    
    func fetchCities() -> [CityModel] {
        let managedObjectContext = cityViewContext
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        let sort = NSSortDescriptor(key: #keyPath(City.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return (try? managedObjectContext?.fetch(fetchRequest)) ?? []
    }
    
    func save() {
        guard cityUpdateContext.hasChanges else { return }
        do {
            try cityUpdateContext.save()
            print("context.save() success")
        } catch let saveError {
            fatalError("Unresolved error: \(saveError), \(saveError.localizedDescription)")
        }
    }
    
    func deleteCity(id: Int) {
        let context = cityUpdateContext//cityPersistentContainer.newBackgroundContext()
//        context.mergePolicy  = NSMergeByPropertyObjectTrumpMergePolicy
        let fetchRequest: NSFetchRequest<City> = NSFetchRequest<City>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
            print("city deleted id = \(id)")
        } catch let deleError {
            NSLog(deleError.localizedDescription)
        }
    }
    
    func cleanCities() {
        let context = cityUpdateContext//cityPersistentContainer.newBackgroundContext()
//        context.mergePolicy  = NSMergeByPropertyObjectTrumpMergePolicy
//        let fetchRequest: NSFetchRequest<City> = NSFetchRequest<City>(entityName: "City")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("cities deleted")
        } catch let error {
            NSLog(error.localizedDescription)
        }
        
//        do {
//            let objects = try context.fetch(fetchRequest)
//            for object in objects {
//                context.delete(object)
//            }
//            try context.save()
//            print("cities deleted")
//        } catch let deleError {
//            NSLog(deleError.localizedDescription)
//        }
    }
    
    private func reset() {
        guard let storeURL = cityPersistentContainer.persistentStoreCoordinator.persistentStores.first?.url else { return }

        cityPersistentContainer.viewContext.performAndWait {
            cityPersistentContainer.viewContext.reset()
            do {
                try cityPersistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
                try cityPersistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                NSLog("[CoreData]: Failed to reset store \(error.localizedDescription)")
            }
        }
    }

}
