//
//  CityListingViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
protocol CityListingDisplayLogic: class {
    func displayGetLocalCitiesSuccess(viewModel: CityListing.ViewModel)
    func displayGetLocalCitiesFailure(viewModel: CityListing.ViewModel)
    func displayGetLocationDetails(success: Bool, message: String)
    func displayDeleteLocationResponse(success: Bool, message: String)
}

class CityListingViewController: BaseViewController {
    var interactor: CityListingBusinessLogic?
    var router: (NSObjectProtocol & CityListingRoutingLogic & CityListingDataPassing)?

    // MARK: IBOutlets
    @IBOutlet weak var tblCities: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    
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
        let interactor = CityListingInteractor()
        let presenter = CityListingPresenter()
        let router = CityListingRouter()
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
        self.addRightNavBarButton(imageName: ImageNames.addIcon.rawValue)
        self.getLocalCities()
    }
    private func getLocalCities() {
        self.interactor?.interactWithGetLocalCities()
    }
    override func rightButtonPressed() {
        self.performSegue(withIdentifier: Segues.map.rawValue, sender: nil)
    }
}
extension CityListingViewController: CityListingDisplayLogic {
    func displayGetLocalCitiesSuccess(viewModel: CityListing.ViewModel) {
        if let cities = self.interactor?.getCitiesList(self.txtSearch.text ?? ""), cities.count > 0 {
            //print(cities)
            self.tblCities.reloadData()
        }
    }
    func displayGetLocalCitiesFailure(viewModel: CityListing.ViewModel) {
        self.showAlertMessage(message: viewModel.message)
    }
    func displayGetLocationDetails(success: Bool, message: String) {
        if success {
            self.tblCities.reloadData()
        } else {
            self.showAlertMessage(message: message)
        }
    }
    func displayDeleteLocationResponse(success: Bool, message: String) {
        if success {
            self.tblCities.reloadData()
        } else {
            self.showAlertMessage(message: message)
        }
    }
}
extension CityListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor?.getCitiesList(self.txtSearch.text ?? "")?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityTableCell.dequeue(from: tableView, for: indexPath)
        if let city = self.interactor?.getCitiesList(self.txtSearch.text ?? "")?[safe: indexPath.row] {
            cell.setData(city: city)
            cell.btnDelete.tag = indexPath.row
            cell.didTapDelete = { [weak self] (index)  in
                guard let weakSelf = self else {
                    print("Memory Released")
                    return
                }
                weakSelf.handleDeleteRecord(index: index)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let city = self.interactor?.getCitiesList(self.txtSearch.text ?? "")?[safe: indexPath.row] {
            self.interactor?.setSelectedCityModel(city: city)
            self.performSegue(withIdentifier: Segues.cityDetail.rawValue, sender: nil)
        }
    }
    private func handleDeleteRecord(index: Int) {
        self.showConfirmationAlert(title: "", message: StaticStrings.confirmDelete, cancelTitle: StaticStrings.no, okTitle: StaticStrings.yes) { (selectedBtn) in
            if selectedBtn == 1 {
                if let city = self.interactor?.getCitiesList(self.txtSearch.text ?? "")?[safe: index], let cityId = city.cityId, cityId.count > 0 {
                    self.interactor?.interactWithDeleteBookmarkedCityWith(cityId: cityId)
                }
            }
        }
    }
}
extension CityListingViewController: MapCallBacks {
    func didSelectLocation(_ latitude: Double, _ longitude: Double) {
        self.interactor?.interactWithGetLocationsDetails(latitude, longitude)
    }
}
extension CityListingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tblCities.reloadData()
    }
}
