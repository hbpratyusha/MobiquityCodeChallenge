//
//  CityDetailPresenter.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CityDetailPresentationLogic {
    func presentGetCurrentDetailsForeCastResponse(success: Bool, message: String)
    func presentGetDailyForecastResponse(success: Bool, message: String)
}

class CityDetailPresenter: CityDetailPresentationLogic {
    weak var viewController: CityDetailDisplayLogic?
    func presentGetCurrentDetailsForeCastResponse(success: Bool, message: String) {
        viewController?.displayGetCurrentForecastDetails(success: success, message: message)
    }
    func presentGetDailyForecastResponse(success: Bool, message: String) {
        viewController?.displayGetDailyForecastDetails(success: success, message: message)
    }
}
