//
//  SettingsPresenter.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentGetDeleteLocationsResponse()
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    func presentGetDeleteLocationsResponse() {
        viewController?.displayDeletedLocationsResponse()
    }
}
