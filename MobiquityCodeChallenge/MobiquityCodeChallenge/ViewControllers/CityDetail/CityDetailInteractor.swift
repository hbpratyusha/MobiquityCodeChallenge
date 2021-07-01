//
//  CityDetailInteractor.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
protocol CityDetailBusinessLogic {
    func interactWithGetForeCastDetails(_ request: CityDetail.Forecast.Request)
    func interactWithGetCurrentDetails(_ request: CityDetail.Forecast.Request)
    func getCurrentForeCast() -> ForeCastModel?
    func getTodayForeCasts() -> [ForeCastModel]?
    func getDailyForeCasts() -> [ForeCastDay]?
}

protocol CityDetailDataStore {
    
}

class CityDetailInteractor: CityDetailBusinessLogic, CityDetailDataStore {
    var presenter: CityDetailPresentationLogic?
    var worker: CityDetailWorker?
    private var todayForecast: ForeCastModel?
    private var todayForecasts: [ForeCastModel] = []
    private var remainingForecasts: [ForeCastDay] = []
    func interactWithGetForeCastDetails(_ request: CityDetail.Forecast.Request) {
        self.worker = CityDetailWorker()
        self.worker?.workOnGetForecastAPI(request: request, completion: { (response) in
            if let list = response.list, list.count > 0 {
                var groupSorted = list.groupSort(byDate: { ($0.date ?? Date()) })
                if groupSorted.count > 0 {
                    self.todayForecasts = groupSorted.removeFirst()
                }
                self.remainingForecasts = []
                for arr in groupSorted {
                    let first = arr.first
                    self.remainingForecasts.append(ForeCastDay(forecastArr: arr, title: first?.title))
                }
                self.presenter?.presentGetDailyForecastResponse(success: true, message: "")
            } else {
                self.presenter?.presentGetDailyForecastResponse(success: false, message: response.message)
            }
        })
    }
    func getCurrentForeCast() -> ForeCastModel? {
        return self.todayForecast
    }
    func getTodayForeCasts() -> [ForeCastModel]? {
        return self.todayForecasts
    }
    func getDailyForeCasts() -> [ForeCastDay]? {
        return self.remainingForecasts
    }
    func interactWithGetCurrentDetails(_ request: CityDetail.Forecast.Request) {
        self.worker = CityDetailWorker()
        self.worker?.workOnGetForecastAPI(request: request, completion: { (response) in
            if let list = response.list, list.count > 0 {
                self.todayForecast = list.first
                self.presenter?.presentGetCurrentDetailsForeCastResponse(success: true, message: "")
            } else {
                self.presenter?.presentGetCurrentDetailsForeCastResponse(success: false, message: response.message)
            }
        })
    }
}
extension Sequence {
    func groupSort(ascending: Bool = true, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
        var categories: [[Iterator.Element]] = []
        for element in self {
            let key = dateKey(element)
            guard let dayIndex = categories.firstIndex(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
                guard let nextIndex = categories.firstIndex(where: { $0.contains(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                    categories.append([element])
                    continue
                }
                categories.insert([element], at: nextIndex)
                continue
            }

            guard let nextIndex = categories[dayIndex].firstIndex(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) else {
                categories[dayIndex].append(element)
                continue
            }
            categories[dayIndex].insert(element, at: nextIndex)
        }
        return categories
    }
}
