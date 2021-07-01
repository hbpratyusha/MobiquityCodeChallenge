//
//  CityDetailWorker.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
class CityDetailWorker {
    func workOnGetForecastAPI(request: CityDetail.Forecast.Request, completion: @escaping ((_ response : CityDetail.Forecast.Response) -> Void)) {
        APIManager.sharedInstance.requestWith(urlString: APIAction.foreCast, params: request.params, model: ForeCastModel.self) { (response) in
            var output = CityDetail.Forecast.Response()
            output.message = response.message
            output.success = response.success
            output.list = response.list
            completion(output)
        }
    }
    func workOnGetCurrentForecastAPI(request: CityDetail.Forecast.Request, completion: @escaping ((_ response : CityDetail.Forecast.Response) -> Void)) {
        APIManager.sharedInstance.requestWith(urlString: APIAction.current, params: request.params, model: ForeCastModel.self) { (response) in
            var output = CityDetail.Forecast.Response()
            output.message = response.message
            output.success = response.success
            output.list = response.list
            completion(output)
        }
    }
}
