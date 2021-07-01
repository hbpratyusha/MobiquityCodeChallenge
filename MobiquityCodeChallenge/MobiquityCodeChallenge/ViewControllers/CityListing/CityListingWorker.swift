//
//  CityListingWorker.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
class CityListingWorker {
    func workOnGetLocalCitiesList(completion: @escaping ((_ response : CityListing.Response) -> Void)) {
        APIManager.sharedInstance.fetchDataFromLocalJson(fileName: StaticFiles.cities, model: CityModel.self) { (res) in
            var output = CityListing.Response()
            output.message = res.message
            output.success = res.success
            let list = DBCity.loadCitiesFromDB()
            if list.count > 0 {
                output.cities = list + (res.list ?? [])
            } else {
                output.cities = res.list
            }
            completion(output)
        }
    }
    func workOnGetLocationDetails(_ latitude: Double, _ longitude: Double, completion: @escaping ((_ response : CityModel?) -> Void)) {
        APIManager.sharedInstance.getLocationFromCoordinates(latitude, longitude) { (strCity, strCountry, strCode) in
            if strCity.count > 0 || strCode.count > 0 || strCountry.count > 0 {
                var city = CityModel()
                city.cityId = strCode.count > 0 ? strCode : (strCity.count > 0 ? strCity : strCountry)
                city.cityName = strCity.count > 0 ? strCity : strCountry
                city.isDefault = false
                city.country = strCountry
                city.latitude = "\(latitude)"
                city.longitude = "\(longitude)"
                completion(city)
            } else {
                completion(nil)
            }
        }
    }
    func checkIfCityAlreadyExistsInDB(cityId: String) -> Bool {
        return DBCity.fetchLocalCity(cityId: cityId, shouldAdd: false) != nil
    }
    func workOnAddCityToDB(city: CityModel) {
        DBCity.insertOrUpdateCityDetails(city.cityId ?? "", city.cityName ?? "", countryName: city.country ?? "", latitude: Double(city.latitude ?? "") ?? 0.0, longitude: Double(city.longitude ?? "") ?? 0.0)
    }
    func workOnGetCityWith(cityId: String) -> CityModel? {
        if let city = DBCity.fetchLocalCity(cityId: cityId) {
            return city.convertToCityModel()
        }
        return nil
    }
    func workOnDeleteCityWith(cityId: String) -> Bool {
        return DBCity.deleteCitiesInDb(cityIds: cityId)
    }
}
