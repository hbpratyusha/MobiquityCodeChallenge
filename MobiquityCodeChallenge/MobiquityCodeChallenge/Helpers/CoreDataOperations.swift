//
//  CoreDataOperations.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import CoreData

class CoreDataOperations: NSObject {
    
    static let shared = CoreDataOperations()
    override init() {
        super.init()
    }
    public func fetchEntityRecords<T>(className: T.Type, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        let context = objAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: className.self))
        if let descriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [descriptor]
        }
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [T] ?? []
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    
    public func fetchEntityRecordsByFetchRequest<T>(fetchRequest: NSFetchRequest<NSFetchRequestResult>, className: T.Type) -> [T] {
        let context = objAppDelegate.managedObjectContext
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [T] ?? []
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func fetchDistinctRecordsByFetchRequest<X, Y>(fetchRequest: NSFetchRequest<NSFetchRequestResult>, className: X.Type, returnClass: Y.Type) -> [Y]? {
        let context = objAppDelegate.managedObjectContext
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [Y] ?? []
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func deleteObjectFromEntity<T>(className: T.Type, key: String, value: Any) -> Bool {
        let context = objAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: className.self))
        let predicate = NSPredicate(format: "\(key) == \(value)")
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            if result.count != 0 {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
                objAppDelegate.saveContext()
                return true
            } else {
                return false
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
    
    public func executeDeleteQueryForEntity<T>(className: T.Type, predicate: NSPredicate) -> Bool{
        let context = objAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: className.self).components(separatedBy: ".").last ?? "")
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            if result.count != 0 {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
            }
            try context.save()
        } catch let error {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    public func batchDeleteEntity<T>(entity: T.Type) -> Bool {
        let context = objAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity.self))
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}
