//
//  MapInteractor.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol MapBusinessLogic {
}

protocol MapDataStore {
}

class MapInteractor: MapBusinessLogic, MapDataStore {
    var presenter: MapPresentationLogic?
    var worker: MapWorker?
}
