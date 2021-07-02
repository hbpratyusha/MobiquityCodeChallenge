//
//  SettingsViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: class {
    func displayDeletedLocationsResponse()
}

class SettingsViewController: BaseViewController, SettingsDisplayLogic {
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    @IBOutlet weak var segmentControl: UISegmentedControl!
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_iPAD {
            self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: FontName.Regular, size: 20), NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
        } else {
            self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: FontName.Regular, size: 15), NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
        }
        if let strUnit = UserDefaults.standard.value(forKey: DefaultKeys.unitKey) as? String, strUnit.lowercased() == StaticStrings.imperial {
            self.segmentControl.selectedSegmentIndex = 1
        } else {
            self.segmentControl.selectedSegmentIndex = 0
        }
    }
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(StaticStrings.metric, forKey: DefaultKeys.unitKey)
        } else {
            UserDefaults.standard.set(StaticStrings.imperial, forKey: DefaultKeys.unitKey)
        }
        APIManager.sharedInstance.shouldReloadForecast = true
    }
    @IBAction func resetAllBookmarks() {
        self.showConfirmationAlert(title: "", message: StaticStrings.confirmAllDelete, cancelTitle: StaticStrings.no, okTitle: StaticStrings.yes) { (btn) in
            if btn == 1 {
                self.interactor?.interactWithDeleteBookmarkedCities()
            }
        }
    }
    func displayDeletedLocationsResponse() {
        APIManager.sharedInstance.shouldReload = true
    }
}
