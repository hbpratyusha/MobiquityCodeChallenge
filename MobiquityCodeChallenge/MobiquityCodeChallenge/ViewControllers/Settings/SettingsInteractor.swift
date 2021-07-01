//
//  SettingsInteractor.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
    func interactWithDeleteBookmarkedCities()
}

protocol SettingsDataStore {
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    var presenter: SettingsPresentationLogic?
    var worker: SettingsWorker?
    func interactWithDeleteBookmarkedCities() {
        self.worker = SettingsWorker()
        self.worker?.workOnDeleteBookmarks()
        self.presenter?.presentGetDeleteLocationsResponse()
    }
}
