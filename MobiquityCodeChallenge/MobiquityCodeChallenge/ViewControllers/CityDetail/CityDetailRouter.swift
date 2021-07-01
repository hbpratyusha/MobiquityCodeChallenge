//
//  CityDetailRouter.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

@objc protocol CityDetailRoutingLogic {
}

protocol CityDetailDataPassing {
    var dataStore: CityDetailDataStore? { get }
}

class CityDetailRouter: NSObject, CityDetailRoutingLogic, CityDetailDataPassing {
    weak var viewController: CityDetailViewController?
    var dataStore: CityDetailDataStore?
  
  // MARK: Routing
}
