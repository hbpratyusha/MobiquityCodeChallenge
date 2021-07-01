//
//  APIEndPoints.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
struct APIEndpoint {
    static let localURL = "http://api.openweathermap.org"
    static let stagingURL = "http://api.openweathermap.org"
    static let liveURL = "http://api.openweathermap.org"
    static let BASEURL = stagingURL
}

struct APIAction {
    static let current             = APIEndpoint.BASEURL + "/data/2.5/weather?"
    static let foreCast            = APIEndpoint.BASEURL + "/data/2.5/forecast?"
}
struct StaticFiles {
    static let cities              = "DefaultCities"
}
struct ResponseKeys {
    static let list = "list"
}
