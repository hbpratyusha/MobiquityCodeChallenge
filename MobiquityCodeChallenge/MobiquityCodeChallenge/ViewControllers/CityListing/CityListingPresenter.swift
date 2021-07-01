//
//  CityListingPresenter.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol CityListingPresentationLogic {
    func presentGetLocalCitiesResponse(response: CityListing.ViewModel)
    func presentGetLocationDetailsResponse(success: Bool, message: String)
    func presentGetDeleteLocationResponse(success: Bool, message: String)
}

class CityListingPresenter: CityListingPresentationLogic {
    weak var viewController: CityListingDisplayLogic?
    func presentGetLocalCitiesResponse(response: CityListing.ViewModel) {
        if response.success {
            viewController?.displayGetLocalCitiesSuccess(viewModel: response)
        } else {
            viewController?.displayGetLocalCitiesFailure(viewModel: response)
        }
    }
    func presentGetLocationDetailsResponse(success: Bool, message: String) {
        viewController?.displayGetLocationDetails(success: success, message: message)
    }
    func presentGetDeleteLocationResponse(success: Bool, message: String) {
        viewController?.displayGetLocationDetails(success: success, message: message)
    }
}
