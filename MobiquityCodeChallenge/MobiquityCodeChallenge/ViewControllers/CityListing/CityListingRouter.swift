//
//  CityListingRouter.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

@objc protocol CityListingRoutingLogic {
    func routeTomapViewWithSegue(_ segue: UIStoryboardSegue)
    func routeTocityDetailWithSegue(_ segue: UIStoryboardSegue)
}

protocol CityListingDataPassing {
    var dataStore: CityListingDataStore? { get }
}

class CityListingRouter: NSObject, CityListingRoutingLogic, CityListingDataPassing {
    weak var viewController: CityListingViewController?
    var dataStore: CityListingDataStore?
  
    // MARK: Routing
    func routeTomapViewWithSegue(_ segue: UIStoryboardSegue) {
        let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? MapViewController
        destination?.delegate = self.viewController
    }
    func routeTocityDetailWithSegue(_ segue: UIStoryboardSegue) {
        let destination = (segue.destination as? CityDetailViewController)
        destination?.selectedCity = dataStore?.selectedCity
    }
}
