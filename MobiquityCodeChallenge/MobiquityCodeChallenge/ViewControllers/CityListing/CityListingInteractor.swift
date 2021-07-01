//
//  CityListingInteractor.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
protocol CityListingBusinessLogic {
    func interactWithGetLocalCities()
    func getCitiesList(_ search: String) -> [CityModel]?
    func interactWithGetLocationsDetails(_ latitude: Double, _ longitude: Double)
    func interactWithDeleteBookmarkedCityWith(cityId: String)
    func setSelectedCityModel(city: CityModel)
}

protocol CityListingDataStore {
    var selectedCity: CityModel? { get set }
}

class CityListingInteractor: CityListingBusinessLogic, CityListingDataStore {
    var selectedCity: CityModel? = nil
    private var cities: [CityModel] = []
    var presenter: CityListingPresentationLogic?
    var worker: CityListingWorker?
    func interactWithGetLocalCities() {
        self.worker = CityListingWorker()
        self.worker?.workOnGetLocalCitiesList(completion: { (response) in
            self.cities = response.cities ?? []
            self.presenter?.presentGetLocalCitiesResponse(response: CityListing.ViewModel(success: response.success, message: response.message))
        })
    }
    func setSelectedCityModel(city: CityModel) {
        self.selectedCity = city
    }
    func interactWithGetLocationsDetails(_ latitude: Double, _ longitude: Double) {
        self.worker = CityListingWorker()
        self.worker?.workOnGetLocationDetails(latitude, longitude, completion: { (response) in
            if let model = response, model.cityId?.count ?? 0 > 0 {
                if self.worker?.checkIfCityAlreadyExistsInDB(cityId: model.cityId ?? "") ?? true {
                    self.presenter?.presentGetLocationDetailsResponse(success: false, message: ErrorMessages.cityExists.rawValue)
                } else {
                    self.worker?.workOnAddCityToDB(city: model)
                    if let city = self.worker?.workOnGetCityWith(cityId: model.cityId ?? "") {
                        let arrNew = [city] + self.cities
                        self.cities = arrNew
                        self.presenter?.presentGetLocationDetailsResponse(success: true, message: "")
                    } else {
                        self.presenter?.presentGetLocationDetailsResponse(success: false, message: ErrorMessages.failedReverseGeocoding.rawValue)
                    }
                }
            } else {
                self.presenter?.presentGetLocationDetailsResponse(success: false, message: ErrorMessages.failedReverseGeocoding.rawValue)
            }
        })
    }
    func interactWithDeleteBookmarkedCityWith(cityId: String) {
        self.worker = CityListingWorker()
        if self.worker?.workOnDeleteCityWith(cityId: cityId) ?? false {
            let arrNew = self.cities.filter { (city) -> Bool in
                city.cityId ?? "" != cityId
            }
            self.cities = arrNew
            self.presenter?.presentGetDeleteLocationResponse(success: true, message: "")
        } else {
            self.presenter?.presentGetDeleteLocationResponse(success: false, message: ErrorMessages.failedLocationDelete.rawValue)
        }
    }
    func getCitiesList(_ search: String) -> [CityModel]? {
        if search.count == 0 {
            if self.cities.count > 0 {
                return self.cities
            }
            return []
        } else {
            return self.cities.filter { (city) -> Bool in
                return (city.cityName?.lowercased().contains(search.lowercased()) ?? false)
            }
        }
    }
}
