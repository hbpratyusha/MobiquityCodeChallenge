//
//  City+CoreDataExtension.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import CoreData

extension DBCity {
    class func insertOrUpdateCityDetails(_ cityId: String = "", _ cityName: String, countryName: String, latitude: Double, longitude: Double) {
        if let managedObject = DBCity.fetchLocalCity(cityId: cityId) {
            managedObject.dbCityId = cityId
            managedObject.dbCityName = cityName
            managedObject.dbCountry = countryName
            managedObject.dbLongitude = longitude
            managedObject.dbLatitude = latitude
            objAppDelegate.saveContext()
        }
    }
    class func loadCitiesFromDB() -> [CityModel] {
        let managedObjectsList = CoreDataOperations.shared.fetchEntityRecords(className: DBCity.self)
        var citiesList = [CityModel]()
        managedObjectsList.forEach { (managedObject) in
            citiesList.append(managedObject.convertToCityModel())
        }
        return citiesList
    }
    func convertToCityModel() -> CityModel {
        let city = CityModel(cityName: self.dbCityName, country: self.dbCountry, latitude: "\(self.dbLatitude)", longitude: "\(self.dbLongitude)", isDefault: false, cityId: self.dbCityId)
        return city
    }
    class func fetchLocalCity(cityId : String, shouldAdd: Bool = true) -> DBCity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(DBCity.self))
        let predicate = NSPredicate(format: "dbCityId == %@", cityId)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        var object : DBCity?
        do {
            let list = try objAppDelegate.managedObjectContext.fetch(fetchRequest) as? [DBCity] ?? []
            if list.count > 0 {
                object = list.first
            }
            else  {
                if shouldAdd {
                    object = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(DBCity.self), into: objAppDelegate.managedObjectContext) as? DBCity
                    object?.dbCityId = cityId
                }
            }
            return object
            
        } catch {
             print("Error while fetching Project")
        }
        return nil
    }
    class func deleteLocalCities() {
        _ = CoreDataOperations.shared.batchDeleteEntity(entity: DBCity.self)
    }
    class func deleteCitiesInDb(cityIds: String) -> Bool {
        var flag = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(DBCity.self))
        let predicate = NSPredicate(format: "dbCityId == %@", cityIds)
        fetchRequest.predicate = predicate
        do {
            let list = try objAppDelegate.managedObjectContext.fetch(fetchRequest) as? [DBCity] ?? []
            if list.count > 0 {
                for object in list {
                    objAppDelegate.managedObjectContext.delete(object)
                }
                objAppDelegate.saveContext()
                flag = true
            } else {
                flag = false
            }
        } catch let error {
            flag = false
            print(error.localizedDescription)
        }
        return flag
    }
}
