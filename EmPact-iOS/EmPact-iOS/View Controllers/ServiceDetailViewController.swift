//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ServiceDetailViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // Outlet for MapView
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var serviceDetailNameLabel: UILabel!
    @IBOutlet weak var serviceDetailAddressLabel: UILabel!
    @IBOutlet weak var serviceDetailDistanceLabel: UILabel!
    @IBOutlet weak var serviceDetailWalkTimeLabel: UILabel!
    @IBOutlet weak var serviceDetailPhoneLabel: UILabel!
    @IBOutlet weak var serviceDetailHoursLabel: UILabel!
    
    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var serviceCoordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    let googleMapsController = GoogleMapsController()
    var networkController: NetworkController?
    
    //var shelterServiceDetail: ShelterIndividualResource?
    var serviceDetail: IndividualResource?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            serviceCoordinates = manager.location?.coordinate
            print("serviceCoordinates: \(serviceCoordinates)")
            locationManager.stopUpdatingLocation()
        } else {
            print("User location is unavailable")
        }
        getServiceDistanceAndDuration()
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedLatitude = serviceCoordinates?.latitude,
            let unwrappedLongitude = serviceCoordinates?.longitude else { return }
        print("User Coordinate location = \(String(describing: unwrappedLatitude)) \(String(describing: unwrappedLongitude))")
        
        self.title = serviceDetail?.name
        
        mapView.delegate = self
        
        // Convert latitude/longitude strings to doubles
        if serviceDetail?.latitude == nil || serviceDetail?.longitude == nil {
            return
            // If there is not latitude and longitude in service details:
            // We could show a message and say map unavailable
            // Then show the user's location.
        } else {
            guard let doubleLatValue = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
                let doubleLongValue = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue
                else {
                print("Latitude or Longitude is not a valid Double")
                return
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: doubleLatValue, longitude: doubleLongValue, zoom: 12.0)
            mapView.camera = camera
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
            marker.title = serviceDetail?.address
            marker.map = mapView
        }
        
        // Change to default to Central Park if no coordinates are retrieved from JSON
        //annotation.coordinate = CLLocationCoordinate2D(latitude: doubleLatValue ?? 40.7829, longitude: doubleLongValue ?? 73.9654)
        
        updateViews()
    
    }
    
    func updateViews() {
        serviceDetailNameLabel.text = serviceDetail?.name
        serviceDetailAddressLabel.text = serviceDetail?.address
        serviceDetailPhoneLabel.text = serviceDetail?.phone
        serviceDetailHoursLabel.text = serviceDetail?.hours
        
        guard let unwrappedDistance = serviceDistance,
        let unwrappedDuration = serviceTravelDuration else { return }
        serviceDetailDistanceLabel.text = unwrappedDistance
        serviceDetailWalkTimeLabel.text = unwrappedDuration
        
    }

    private func getServiceDistanceAndDuration() {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates,
            let unwrappedDestLatitude  = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
            let unwrappedDestLongitude = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue else { return }
        
        googleMapsController.fetchServiceDistance(unwrappedServiceCoordinate.latitude, unwrappedServiceCoordinate.longitude, unwrappedDestLatitude, unwrappedDestLongitude) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }
            
            self.serviceDistance = self.googleMapsController.serviceDistance
            self.serviceTravelDuration = self.googleMapsController.serviceTravelDuration
            
            print("serviceDistance: \(String(describing: self.serviceDistance))")
            print("serviceTravelDuration: \(String(describing: self.serviceTravelDuration))")
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
        
    }

}

//extension ServiceDetailViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            serviceCoordinates = manager.location?.coordinate
//            print("serviceCoordinates: \(serviceCoordinates)")
//            locationManager.stopUpdatingLocation()
//        } else {
//            print("User location is unavailable")
//        }
//    }
//
//}
