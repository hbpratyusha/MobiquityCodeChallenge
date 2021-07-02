//
//  CityDetailViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit

protocol CityDetailDisplayLogic: class {
    func displayGetCurrentForecastDetails(success: Bool, message: String)
    func displayGetDailyForecastDetails(success: Bool, message: String)
}

class CityDetailViewController: BaseViewController, CityDetailDisplayLogic {
    var interactor: CityDetailBusinessLogic?
    var router: (NSObjectProtocol & CityDetailRoutingLogic & CityDetailDataPassing)?
    var selectedCity: CityModel?
    
    @IBOutlet weak var currentForecastGrid: UICollectionView!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblCurrentWeather: UILabel!
    @IBOutlet weak var imgCurrentWeather: UIImageView!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblCurrentHumidity: UILabel!
    @IBOutlet weak var lblCurrentWinds: UILabel!
    @IBOutlet weak var tblForecast: UITableView!
    @IBOutlet weak var todayView: UIView!
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
        let interactor = CityDetailInteractor()
        let presenter = CityDetailPresenter()
        let router = CityDetailRouter()
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
        self.lblCurrentDate?.text = "Today - \(self.selectedCity?.cityName ?? "")"
        //self.navigationItem.title = self.selectedCity?.cityName ?? ""
        let segment: UISegmentedControl = UISegmentedControl(items: ["Today", "Week"])
        segment.sizeToFit()
        segment.selectedSegmentTintColor = UIColor.AppColor()
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: FontName.Medium, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
        segment.addTarget(self, action: #selector(self.segmentTapped(sender:)), for: UIControl.Event.valueChanged)
        self.navigationItem.titleView = segment
        self.callCurrentAPI()
        self.callForecastAPI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if APIManager.sharedInstance.shouldReloadForecast {
            APIManager.sharedInstance.shouldReloadForecast = false
            self.callCurrentAPI()
            self.callForecastAPI()
        }
    }
    @objc func segmentTapped(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.todayView.isHidden = false
            self.tblForecast.isHidden = true
        } else {
            self.todayView.isHidden = true
            self.tblForecast.isHidden = false
        }
    }
    private func callCurrentAPI() {
        self.showProgressHud()
        var req = CityDetail.Forecast.Request()
        req.appId = appKey
        req.latitude = self.selectedCity?.latitude ?? ""
        req.longitude = self.selectedCity?.longitude ?? ""
        if let strUnit = UserDefaults.standard.value(forKey: DefaultKeys.unitKey) as? String {
            req.units = strUnit
        } else {
            req.units = StaticStrings.metric
        }
        self.interactor?.interactWithGetCurrentDetails(req)
    }
    private func callForecastAPI() {
        var req = CityDetail.Forecast.Request()
        req.appId = appKey
        req.latitude = self.selectedCity?.latitude ?? ""
        req.longitude = self.selectedCity?.longitude ?? ""
        if let strUnit = UserDefaults.standard.value(forKey: DefaultKeys.unitKey) as? String {
            req.units = strUnit
        } else {
            req.units = StaticStrings.metric
        }
        self.interactor?.interactWithGetForeCastDetails(req)
    }
    private func fillCurrentDetails() {
        if let today = self.interactor?.getCurrentForeCast() {
            if let weather = today.weatherData?.first {
                self.lblCurrentWeather?.text = weather.description ?? ""
                self.imgCurrentWeather?.image = UIImage(named: weather.icon ?? "")
            }
            self.lblCurrentWinds.text = "\(today.windInfo?.speed ?? 0)"
            self.lblCurrentHumidity.text = "\(today.mainData?.humidity ?? 0)"
            self.lblCurrentTemp.text = "\(today.mainData?.temperature ?? 0)"
        }
    }
}
extension CityDetailViewController {
    func displayGetCurrentForecastDetails(success: Bool, message: String) {
        DispatchQueue.main.async {
            self.hideProgressHud()
            if success {
                self.fillCurrentDetails()
            } else {
                self.showAlertMessage(message: message)
            }
        }
    }
    func displayGetDailyForecastDetails(success: Bool, message: String) {
        DispatchQueue.main.async {
            if success {
                self.currentForecastGrid.reloadData()
                self.tblForecast.reloadData()
            } else {
                
            }
        }
    }
}
extension CityDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ForecastCell.dequeue(from: collectionView, for: indexPath)
        if let foreCast = self.interactor?.getTodayForeCasts()?[safe: indexPath.row] {
            cell.setData(city: foreCast)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interactor?.getTodayForeCasts()?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IS_iPAD {
            return CGSize(width: 200, height: 200)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
}
extension CityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeekForeCastCell.dequeue(from: tableView, for: indexPath)
        if let foreCast = self.interactor?.getDailyForeCasts()?[safe: indexPath.row] {
            cell.setData(city: foreCast)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor?.getDailyForeCasts()?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IS_iPAD {
            return 250
        } else {
            return 150
        }
    }
}
