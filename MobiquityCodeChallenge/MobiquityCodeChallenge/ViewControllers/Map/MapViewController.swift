//
//  MapViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright (c) 2021 Mobiquity. All rights reserved.
//

import UIKit
import MapKit
protocol MapDisplayLogic: class {
}
protocol MapCallBacks: class {
    func didSelectLocation(_ latitude: Double, _ longitude: Double)
}
class MapViewController: BaseViewController, MapDisplayLogic {
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    @IBOutlet weak var mapVW: MKMapView!
    private var latestLocation: CLLocationCoordinate2D!
    private let locationManager = CLLocationManager()
    private var pin: MKPointAnnotation!
    weak var delegate: MapCallBacks?
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
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
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
        self.mapVW.delegate = self
        self.addLeftNavBarButton(imageName: ImageNames.closeIcon.rawValue)
        self.addRightNavBarButton(imageName: ImageNames.tickMark.rawValue)
        if let location = APIManager.sharedInstance.currentLocation {
            self.latestLocation = location
            self.addAnnotation()
        } else {
            self.initiateLocationServices()
        }
    }
    override func rightButtonPressed() {
        APIManager.sharedInstance.currentLocation = self.latestLocation
        self.delegate?.didSelectLocation(self.latestLocation?.latitude ?? 0, self.latestLocation?.longitude ?? 0)
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    override func leftButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    private func initiateLocationServices() {
        if Utility.isConnectedToNetwork() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    private func addAnnotation() {
        if self.pin != nil {
            self.mapVW.removeAnnotation(self.pin)
            self.pin = nil
        }
        if let loc = self.latestLocation {
            self.pin = MKPointAnnotation()
            self.pin.title = "Location"
            self.pin.coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
            self.mapVW.setCenter(loc, animated: false)
            self.mapVW.addAnnotation(self.pin)
        }
    }
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pav: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
         if pav == nil {
            pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pav?.isDraggable = true
            pav?.canShowCallout = true
         } else {
            pav?.annotation = annotation
         }
        return pav
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            self.latestLocation = view.annotation?.coordinate
        }
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.latestLocation == nil && manager == locationManager {
            guard let userLocation: CLLocation = locations.first else {
                return
            }
            APIManager.sharedInstance.currentLocation = userLocation.coordinate
            self.latestLocation = userLocation.coordinate
            manager.stopUpdatingLocation()
            self.addAnnotation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager == locationManager {
            self.latestLocation = defaultLocation
            APIManager.sharedInstance.currentLocation = self.latestLocation
            manager.stopUpdatingLocation()
            self.addAnnotation()
        }
    }
}
