//
//  CityListingModels.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

enum CityListing {
    struct Request {
        
    }
    struct Response {
        var cities: [CityModel]?
        var success: Bool = false
        var message: String = ""
    }
    struct ViewModel {
        var success: Bool = false
        var message: String = ""
    }
}
struct CityModel: Codable {
    var cityName, country : String?
    var latitude, longitude: String?
    var isDefault: Bool = true
    var cityId: String?
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case latitude = "lat"
        case longitude = "lng"
        case country = "Country"
    }
}
