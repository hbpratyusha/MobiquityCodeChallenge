//
//  CityDetailModels.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
enum CityDetail {
    enum Forecast {
        struct Request {
            var latitude: String = ""
            var longitude: String = ""
            var appId: String = ""
            var units: String = ""
            var params: [String : Any]? {
                return ["lat": latitude, "lon": longitude, "appid": appId, "units": units]
            }
        }
        struct Response {
            var list: [ForeCastModel]?
            var success: Bool = false
            var message: String = ""
        }
    }
}
struct ForeCastModel: Codable {
    let weatherData: [WeatherModel]?
    let cloudinessInfo: CloudModel?
    let mainData: MainModel?
    let windInfo: WindModel?
    let dateText: String?
    let dateTimeStamp: Double?
    var date: Date? {
        return Utility.dateFormatter.date(from: dateText ?? "")
        //Date(timeIntervalSince1970: dateTimeStamp ?? 0)
    }
    var title: String? {
        return Utility.dateFormatterText.string(from: date ?? Date())
    }
    var time: String? {
        return Utility.dateFormatterTime.string(from: date ?? Date())
    }
    enum CodingKeys: String, CodingKey {
        case mainData = "main"
        case weatherData = "weather"
        case cloudinessInfo = "clouds"
        case windInfo = "wind"
        case dateText = "dt_txt"
        case dateTimeStamp = "dt"
    }
    
}
struct ForeCastDay: Codable {
    let forecastArr: [ForeCastModel]?
    let title: String?
}
struct MainModel: Codable {
    let temperature, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, groundLevel, humidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
    }
}
struct WeatherModel: Codable {
    let main, description, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}
struct CloudModel: Codable {
    let cloudiness: Double?
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}
struct WindModel: Codable {
    let speed, degree, gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case degree = "deg"
        case gust
        case speed
    }
}
